#!/usr/bin/env ruby
require 'xml'

file = File.open("./sample.xml")
raw_xml = file.read

source = XML::Parser.string(raw_xml)
content = source.parse

entries = content.root.find('./logentry')
entries.each do |entry|
  revision = entry['revision']
  puts revision
  
  author = entry.find_first('author').content
  puts author
  
  date = entry.find_first('date').content
  puts date
  
  paths = entry.find('./paths/path')
  paths.each do |path|
    action = path['action']
    puts action
    
    full_path = path.content
    puts full_path
    
    file_paths = full_path.partition(/(branch|tag|trunk)/i)
   
    project_root = file_paths[0]
    puts project_root
    
    file_path = file_paths[2]
    puts file_path
  end
  
  message = entry.find_first('msg')
  puts message
  
  puts '------------------------------------------'
end