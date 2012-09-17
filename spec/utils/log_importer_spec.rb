require 'spec_helper'

describe LogImporter, :broken_in_spork => true do

  it "should require a project id and a log" do
    LogImporter.new(1, '<log/>')
  end

  before(:each) do
    @importer = LogImporter.new(1, '<log/>')
  end
  
  describe "parse xml" do

    describe "success" do

      before(:each) do
        @valid_xml = '<node>value</node>'
      end

      it "should accept a string as an input" do
        @importer.parse(@valid_xml)
      end

      it "should return an XML Document object" do
        @importer.parse(@valid_xml).should be_a(LibXML::XML::Document)
      end

      it "should assign the XML document to the xml attribute" do
        @importer.parse(@valid_xml)
        @importer.instance_variable_get(:@xml).to_s.should include(@valid_xml)
      end
    end

    describe "failure" do

      it "should return a parsing error" do
        lambda do
          @importer.parse('invalid xml')
        end.should raise_error(ImportError, "Fatal error: Start tag expected, '<' not found at :1.")
      end
    end
  end

  describe "validate xml" do

    before(:each) do
      @schema = File.join(Rails.root, 'spec/fixtures/files/schema.xsd')
    end

    it "should accept an xml document object and an xsd file location as inputs" do
      xml = LibXML::XML::Document.string('<node>value</node>')
      @importer.validate(xml, @schema)
    end

    describe "success" do

      before(:each) do
        @xml = LibXML::XML::Document.string('<node>value</node>')
      end

      it "should return true" do
        @importer.validate(@xml, @schema).should == true
      end
    end

    describe "failure" do

      it "should return a validation error" do
        invalid_xml = LibXML::XML::Document.string('<invalidNode>value</invalidNode>')
        lambda do
          @importer.validate(invalid_xml, @schema)
        end.should raise_error(ImportError, "Error: Element 'invalidNode': No matching global declaration available for the validation root. at :1.")
      end
    end
  end

  describe "find project" do

    describe "success" do

      before(:each) do
        @project = Project.create(:name => 'Test Project')
        @importer.instance_variable_set(:@project_id, @project.id)
      end

      it "should return a project object" do
        @importer.find_project.should be_a(Project)
      end

      it "should return the right project" do
        @importer.find_project.should == @project
      end
    end

    describe "failure" do

      it "should throw an exception" do
        lambda do
          @importer.find_project
        end.should raise_error(ImportError, "Project with id '1' not found! Stopping import.")
      end
    end
  end

  describe "find log entries" do

    it "should return a collection of log entries" do
      first = 'first'
      second = 'second'
      @importer.parse("<log><logentry>#{first}</logentry><logentry>#{second}</logentry></log>")
      entries = @importer.find_log_entries
      entries.size.should == 2
      entries[0].content.should == first
      entries[1].content.should == second
      end
  end

  describe "find author" do

    before(:each) do
      @author = 'Test Author'
      @importer.parse("<log><logentry><author>#@author</author></logentry></log>")
      @log_entry = @importer.find_log_entries[0]
    end

    it "should accept a log entry as an input" do
      @importer.find_author_for(@log_entry)
    end

    it "should return the name of the author" do
      @importer.find_author_for(@log_entry).should == @author
    end
  end

  describe "find entries for author" do

    it "should return all commits for a specified author" do
      author = 'Test Author'
      @importer.parse("<log><logentry><author>#{author}</author></logentry></log>")
      entries = @importer.find_entries_for(author)
      entries.size.should == 1
      entries[0].find_first('author').content.should == author
    end
  end

  describe "find message" do

    before(:each) do
      @message = 'Test Message'
      @importer.parse("<log><logentry><msg>#@message</msg></logentry></log>")
      @log_entry = @importer.find_log_entries[0]
    end

    it "should accept a log entry as an input" do
      @importer.find_message_for(@log_entry)
    end

    it "should return the message" do
      @importer.find_message_for(@log_entry).should == @message
    end
  end

  describe "find date" do

    before(:each) do
      @date = '2012-09-12T00:00:00.000000A'
      @importer.parse("<log><logentry><date>#@date</date></logentry></log>")
      @log_entry = @importer.find_log_entries[0]
    end

    it "should accept a log entry as an input" do
      @importer.find_date_for(@log_entry)
    end

    it "should return the date" do
      @importer.find_date_for(@log_entry).should == @date
    end
  end

  describe "find changes for commit" do

    it "should return all the changes for a specified commit" do
      commit = '1'
      path = 'Test Change'
      @importer.parse("<log><logentry revision=\"#{commit}\"><paths><path>#{path}</path></paths></logentry></log>")

      changes = @importer.find_changes_for(commit)
      changes.size.should == 1
      changes[0].content.should == path
    end
  end

  describe "find file paths for change" do

    it "should return an array of file paths for a specified change" do

      root = '/'
      branch = 'trunk'
      file_path = '/location/file.txt'
      path = root + branch + file_path
      @importer.parse("<log><logentry revision=\"1\"><paths><path>#{path}</path></paths></logentry></log>")

      paths = @importer.find_file_paths_for(@importer.find_changes_for('1')[0])
      paths.size.should == 2
      paths[1][0].should == root
      paths[1][2].should == file_path
      paths[0].should == path
    end
  end

  describe "create committers" do

    before(:each) do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'))
      @importer = LogImporter.new(Project.create(:name => "Test Project").id, log.read)
      @importer.valid?
    end

    it "should create a new committer" do
      lambda do
        @importer.create_committers
      end.should change(Committer, :count).by(1)
    end

    it "should not create a new committer if they already exist" do
      @importer.instance_variable_set(:@log,  File.open(File.join(Rails.root, 'spec/fixtures/files/complex_log.xml')).read)
      @importer.valid?

      lambda do
        @importer.create_committers
      end.should change(Committer, :count).by(1)
    end
  end

  describe "create commits" do

    before(:each) do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'))
      @importer = LogImporter.new(Project.create(:name => "Test Project").id, log.read)
      @importer.valid?
      @importer.create_committers
    end

    it "should create a new commit" do
      lambda do
        @importer.create_commits
      end.should change(Commit, :count).by(1)
    end
  end

  describe "create changes" do

    before(:each) do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'))
      @importer = LogImporter.new(Project.create(:name => "Test Project").id, log.read)
      @importer.valid?
      @importer.create_committers
      @importer.create_commits
    end

    it "should crate a new change" do
      lambda do
        @importer.create_changes
      end.should change(Change, :count).by(1)
    end
  end

  describe "import" do

    it "should create committers, commits, and changes for a project" do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'))
      importer = LogImporter.new(Project.create(:name => 'Test Project').id, log.read)
      lambda do
        importer.import
      end.should change(Committer, :count).by(1) && change(Commit, :count).by(1) && change(Change, :count).by(1)
    end
  end
end
