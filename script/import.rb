#!/usr/bin/env ruby
require 'xml'
require 'mysql'

class Import

  def action_and_paths(revisionName)
    paths = @entry.find('./paths/path')
    revisionId = @mysql.query("SELECT id FROM commits WHERE revision = '#{revisionName}'").fetch_row[0]
    now = get_current_time()
    paths.each do |path|
      action = path['action']
      full_path = path.content.gsub(/'/, "")
      file_paths = full_path.partition(/(branches|tags|trunk)/i)
      project_root = file_paths[0]
      file_path = file_paths[2]
      @mysql.query("INSERT INTO changes (revision, status, project_root, filepath, fullpath, created_at, updated_at, commit_id) VALUES('#{revisionName}', '#{action}', '#{project_root}', '#{file_path}', '#{full_path}', '#{now}', '#{now}', '#{revisionId}')")
    end
  end

  def message
    return @entry.find_first('msg').content.strip.gsub(/[\n]+/, "").gsub(/'/, "")
  end
  
  def date
    return @entry.find_first('date').content
  end

  def revision(author)
    revisionName = @entry['revision']
    revisions = @mysql.query("SELECT revision FROM commits WHERE revision = '#{revisionName}'")
    if revisions.fetch_row.nil?
      now = get_current_time()
      committer_id = @mysql.query("SELECT id FROM committers WHERE name = '#{author}'").fetch_row[0]
      @mysql.query("INSERT INTO commits (revision, committer_id, datetime, message, created_at, updated_at) VALUES('#{revisionName}', '#{committer_id}', '#{date()}', '#{message()}', '#{now}', '#{now}');")
    end
    
    action_and_paths(revisionName)
  end
  
  def create_commit
    author = @entry.find_first('author').content
    authors = @mysql.query("SELECT name FROM committers WHERE name = '#{author}'")
    if authors.fetch_row.nil?
      now = get_current_time()
      @mysql.query("INSERT INTO committers (name, created_at, updated_at, project_id) VALUES('#{author}', '#{now}', '#{now}', '#{@project}');")
    end

    revision(author)
  end
  
  def create_project
    now = get_current_time()
    name = 'Google V8'
    @mysql.query("INSERT INTO projects (name, description, created_at, updated_at) VALUES('#{name}', 'Google Chrome V8 Engine', '#{now}', '#{now}');")
    @project = @mysql.query("SELECT id FROM projects WHERE name = '#{name}'").fetch_row[0]
  end
  
  def get_current_time
    return Time.now.strftime("%F %T")
  end

  def import_entries
    entries = parse_xml().root.find('./logentry')
    entries.each do |entry|
      @entry = entry
      create_commit()
    end
  end

  def parse_xml
    file = File.open("./log.xml")
    raw_xml = file.read
    source = XML::Parser.string(raw_xml)
    return source.parse
  end
  
  def disconnect_from_database
    @mysql.close()
  end
  
  def connect_to_database
    @mysql = Mysql.init()
    @mysql.connect('localhost', 'root', '')
    @mysql.select_db('subversion-stats_development')
  end

  if __FILE__ == $PROGRAM_NAME
    this = Import.new()
    this.connect_to_database()
    this.create_project()
    this.import_entries()
    this.disconnect_from_database()
  end
end
