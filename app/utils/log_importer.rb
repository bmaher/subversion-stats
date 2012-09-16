require 'xml'
require 'import_error'

class LogImporter

  LibXML::XML::Error.set_handler(&LibXML::XML::Error::QUIET_HANDLER)

  attr_accessor :project_id
  attr_accessor :log
  attr_accessor :xml

  def initialize(project_id, log)
    self.project_id = project_id
    self.log = log
  end

  def import
    if valid?
      create_committers
      create_commits
      create_changes
    else
      raise ImportError.new, "Log validation failed! Please provide a valid SVN log file."
    end
  end

  def valid?
      validate(parse(self.log), 'lib/xsd/svnlog.xsd')
  end

  def parse(xml)
    begin
      self.xml = LibXML::XML::Document.string(xml)
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
        @committers << project.committers.create(:name => author)
      end
    end
  end

  def find_project
    begin
      Project.find(self.project_id)
    rescue ActiveRecord::RecordNotFound
      raise ImportError.new(self.project_id), "Project with id '#{self.project_id}' not found! Stopping import."
    end
  end

  def find_log_entries
    self.xml.root.find('./logentry')
  end

  def find_author_for(entry)
    entry.find_first('author').content
  end

  def create_commits
    @commits = []
    @committers.each do |committer|
      find_entries_for(committer.name).each do |entry|
        @commits << committer.commits.create(:revision => entry['revision'],
                                             :message  => find_message_for(entry),
                                             :datetime => find_date_for(entry))
      end
    end
  end

  def find_entries_for(author)
    self.xml.root.find("./logentry/author[text()='#{author}']/..")
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
       find_changes_for(commit.revision).each do |change|
         file_paths = find_file_paths_for(change)
         inserts.push "(\"#{commit.revision}\", \"#{change['action']}\", \"#{file_paths[1][0]}\", \"#{file_paths[1][2]}\", \"#{file_paths[0]}\", \"#{now}\", \"#{now}\", \"#{commit.id}\")"
       end
    end
    execute_single_insert_with(inserts)
  end

  def find_changes_for(commit)
    self.xml.root.find("./logentry[@revision=#{commit}]/paths/path")
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