require 'xml'
require 'import_error'

class LogImporter

  LibXML::XML::Error.set_handler(&LibXML::XML::Error::QUIET_HANDLER)

  def initialize(project_id, log)
    @project_id = project_id
    @log = log
    @xml = nil
  end

  def import
    if valid?
      create_committers
      create_commits
      begin
        create_changes
      rescue ImportError => import_error
        warn import_error.message
      end
    else
      raise ImportError.new, "Log validation failed! Please provide a valid SVN log file."
    end
  end

  def valid?
      validate(parse(@log), 'lib/xsd/svnlog.xsd')
  end

  def parse(xml)
    begin
      @xml = LibXML::XML::Document.string(xml)
    rescue LibXML::XML::Error => parsing_error
      raise ImportError.new, parsing_error.message
    end
  end
  
  def validate(xml, schema_file)
    begin
      schema = LibXML::XML::Schema.document(LibXML::XML::Document.file(schema_file))
      xml.validate_schema(schema)
    rescue LibXML::XML::Error => validation_error
      raise ImportError.new, validation_error.message
    end
  end

  def create_committers
    @committers = []
    project = find_project
    find_log_entries.each do |entry|
      author = find_author_for(entry)
      unless project.committers.find_by_name(author)
        committer = project.committers.new(:name => author)
        committer.save!
        @committers << committer
      end
    end
  end

  def find_project
    begin
      Project.find(@project_id)
    rescue ActiveRecord::RecordNotFound
      raise ImportError.new(@project_id), "Project with id '#@project_id' not found! Stopping import."
    end
  end

  def find_log_entries
    @xml.root.find('./logentry')
  end

  def find_author_for(entry)
    entry.find_first('author').content
  end

  def create_commits
    @commits = []
    @committers.each do |committer|
      find_entries_for(committer.name).each do |entry|
        commit = committer.commits.new(:revision   => entry['revision'],
                                       :message    => find_message_for(entry),
                                       :datetime   => find_date_for(entry),
                                       :project_id => committer.project_id)
        commit.save!
        @commits << commit
      end
    end
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
    inserts = []
    now = Time.now.strftime('%F %T')
    @commits.each do |commit|
      changes = find_changes_for(commit.revision)
      if changes.size == 0
        raise ImportError.new, "No changes found for commit #{commit.id}"
      end
      changes.each do |change|
        file_paths = find_file_paths_for(change)
        inserts.push "(\"#{commit.revision}\", \"#{change['action']}\", \"#{file_paths[1][0]}\", \"#{file_paths[1][2]}\", \"#{file_paths[0]}\", \"#{now}\", \"#{now}\", \"#{commit.id}\")"
      end
      execute_single_insert_with(inserts)
    end
  end

  def find_changes_for(revision)
    @xml.root.find("./logentry[@revision=#{revision}]/paths/path")
  end

  def find_file_paths_for(change)
    file_paths = []
    file_paths << change.content.gsub(/'/, '')
    file_paths << file_paths[0].partition(/(branches|tags|trunk)/i)
  end

  def execute_single_insert_with(inserts)
    sql = "INSERT INTO changes (revision, status, project_root, filepath, fullpath, created_at, updated_at, commit_id) VALUES #{inserts.join(", ")}"
    ActiveRecord::Base.connection.execute sql
  end
end