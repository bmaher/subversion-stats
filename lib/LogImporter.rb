require 'xml'

class LogImporter
    
  def initialize(project, log)
    @project = project
    @log = log
  end
  
  def import
    if valid?
      create_committers
      create_commits
      create_changes
    end
  end
  
  def valid?
    @document = LibXML::XML::Document.io(@log)
    schema = LibXML::XML::Schema.new('lib/xsd/svnlog.xsd')
      result = @document.validate_schema(schema) do |message,flag|
        log.debug(message)
      end
  end
  
  def log_entries
    @document.root.find('./logentry')
  end
  
  def find_author(entry)
    entry.find_first('author').content
  end
  
  def find_message(entry)
    entry.find_first('msg').content.strip.gsub(/[\n]+/, "").gsub(/'/, "")
  end
  
  def find_date(entry)
    entry.find_first('date').content
  end
  
  def create_committers
    @committers = Array.new
    log_entries.each do |entry|
      name = find_author(entry)
      unless @project.committers.find_by_name(name)
        @committers << @project.committers.create(:name => name)
      end
    end
  end
  
  def create_commits
    @commits = Array.new
    @committers.each do |committer|
      log_entries.each do |entry|
        if find_author(entry) == committer.name
          @commits << committer.commits.create(:revision => entry['revision'],
                                                   :message  => find_message(entry),
                                                   :datetime => find_date(entry))
        end
      end
    end
  end
  
  def create_changes
    @commits.each do |commit|
      log_entries.each do |entry|
        if entry['revision'] == commit.revision.to_s
          @inserts = Array.new
          entry.find('./paths/path').each do |change|
            now = Time.now.strftime("%F %T")
            full_path = change.content.gsub(/'/, "")
            file_paths = full_path.partition(/(branches|tags|trunk)/i)
            @inserts.push "(\"#{entry['revision']}\", \"#{change['action']}\", \"#{file_paths[0]}\", \"#{file_paths[2]}\", \"#{full_path}\", \"#{now}\", \"#{now}\", \"#{commit.id}\")"
          end
        end
      end
    end
    sql = "INSERT INTO changes (revision, status, project_root, filepath, fullpath, created_at, updated_at, commit_id) VALUES #{@inserts.join(", ")}"
    ActiveRecord::Base.connection.execute sql
  end
end