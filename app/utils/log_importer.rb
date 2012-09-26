require 'xml'
require 'errors'

class LogImporter

  LibXML::XML::Error.set_handler(&LibXML::XML::Error::QUIET_HANDLER)

  def initialize(project_id, log)
    @project = find_project(project_id)
    @log = log
    @xml = nil
    @inserts = []
    @changes_count = 0
  end

  def find_project(project_id)
    begin
      Project.find(project_id, :include => [:committers, :commits])
    rescue ActiveRecord::RecordNotFound
      raise Errors::ImportError.new(project_id), "Project with id '#{project_id}' not found! Stopping import."
    end
  end

  def import
    if valid?
      create_committers
      create_commits
      create_changes
    else
      raise Errors::ImportError.new, "Log validation failed! Please provide a valid SVN log file."
    end
  end

  def valid?
      validate(parse(@log), 'lib/xsd/svnlog.xsd')
  end

  def parse(xml)
    begin
      @xml = LibXML::XML::Document.string(xml)
    rescue LibXML::XML::Error => parsing_error
      raise Errors::ImportError.new, parsing_error.message
    end
  end
  
  def validate(xml, schema_file)
    begin
      schema = LibXML::XML::Schema.document(LibXML::XML::Document.file(schema_file))
      xml.validate_schema(schema)
    rescue LibXML::XML::Error => validation_error
      raise Errors::ImportError.new, validation_error.message
    end
  end

  def create_committers
    @committers = []
    find_new_authors.each do |new_author|
      committer = @project.committers.new(:name => new_author)
      committer.save!
      @committers << committer
    end
  end

  def find_log_entries
    @xml.root.find('./logentry')
  end

  def find_authors
    authors = []
    @xml.root.find('./logentry/author').each{ |author| authors.push(author.content) }
    authors.uniq
  end

  def find_new_authors
    if @project.committers.nil?
      find_authors
    else
      find_authors - @project.committers.pluck(:name)
    end
  end

  def find_author_for(entry)
    entry.find_first('author').content
  end

  def create_commits
    @commits = []
    @project.reload
    @project.committers.each do |committer|
      find_entries_for(committer.name).each do |entry|
        @revision = entry['revision']
        next if commit_exists?
        commit = committer.commits.new(:revision   => @revision,
                                       :message    => find_message_for(entry),
                                       :datetime   => find_date_for(entry),
                                       :project_id => @project.id )
        commit.save!
        @commits << commit
      end
    end
  end

  def commit_exists?
    @project.commits.any?{ |commit| commit.revision == @revision.to_i }
  end

  def find_entries_for(author)
    @xml.root.find("./logentry/author[text()='#{author}']/..")
  end

  def find_message_for(entry)
    entry.find_first('msg').content.strip.gsub(/[\n]+/, '').gsub(/'/, '')
  end

  def find_date_for(entry)
    entry.find_first('date').content
  end

  def create_changes
    now = Time.now.strftime('%F %T')
    @commits.each do |commit|
      find_changes_for(commit.revision).each do |change|
        file_paths = find_file_paths_for(change)
        @inserts.push "(\"#{commit.revision}\", \"#{change['action']}\", \"#{file_paths[1][0]}\", \"#{file_paths[1][2]}\", \"#{file_paths[0]}\", \"#{now}\", \"#{now}\", \"#{commit.id}\")"
      end
      execute_single_insert
    end
  end

  def find_changes_for(revision)
    changes = @xml.root.find("./logentry[@revision=#{revision}]/paths/path")
    if changes.size == 0
      warn "No changes found for revision #{revision}. Project id = #{@project.id}"
    else
      @changes_count += 1
      changes
    end
  end

  def find_file_paths_for(change)
    file_paths = []
    file_paths << change.content.gsub(/'/, '')
    file_paths << file_paths[0].partition(/(branches|tags|trunk)/i)
  end

  def execute_single_insert
    unless @changes_count == 0
      sql = "INSERT INTO changes (revision, status, project_root, filepath, fullpath, created_at, updated_at, commit_id) VALUES #{@inserts.join(", ")}"
      ActiveRecord::Base.connection.execute sql
      @inserts.clear
    end
  end
end