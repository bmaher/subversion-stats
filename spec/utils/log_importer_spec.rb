require 'spec_helper'

describe LogImporter, :broken_in_spork => true do

  it "should require a project id and a log" do
    project = FactoryGirl.create(:project)
    LogImporter.new(project.id, '<log/>')
  end

  describe "xml" do

    before(:each) do
      project = FactoryGirl.create(:project)
      @importer = LogImporter.new(project.id, '<log/>')
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
          end.should raise_error(Errors::ImportError, "Fatal error: Start tag expected, '<' not found at :1.")
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
          end.should raise_error(Errors::ImportError, "Error: Element 'invalidNode': No matching global declaration available for the validation root. at :1.")
        end
      end
    end

    describe "find xml elements" do

      describe "find project" do

        describe "success" do

          before(:each) do
            @project = Project.create(:name => 'Test Project', :user_id => 1)
            @importer.instance_variable_set(:@project_id, @project.id)
          end

          it "should return a project object" do
            @importer.find_project(@project.id).should be_a(Project)
          end

          it "should return the right project" do
            @importer.find_project(@project.id).should == @project
          end
        end

        describe "failure" do

          it "should throw an exception" do
            lambda do
              LogImporter.new(0, '<\log>').find_project(0)
            end.should raise_error(Errors::ImportError, "Project with id '0' not found! Stopping import.")
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

      describe "find authors" do

        before(:each) do
          @first_author = 'First Author'
          @second_author = 'Second Author'
          @third_author = 'Second Author'
          @importer.parse("""<log>
                              <logentry>
                                <author>#@first_author</author>
                              </logentry>
                              <logentry>
                                <author>#@second_author</author>
                              </logentry>
                              <logentry>
                                <author>#@third_author</author>
                              </logentry>
                             </log>""")
        end

        it "should return an array of all authors" do
          @importer.find_authors.should be_an Array
        end

        it "should only return one instance of an author if multiple entries with the same author exist" do
          authors = @importer.find_authors
          authors.size.should eq 2
          authors[0].should eq @first_author
          authors[1].should eq @second_author
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
    end
  end

  describe "create entries" do

    before(:each) do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'))
      @project = Project.create(:name => "Test Project", :user_id => 1)
      @importer = LogImporter.new(@project.id, log.read)
      @importer.valid?
    end

    describe "create committers" do

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

      it "should increase the counter cache" do
        lambda do
          @importer.create_committers
          @project.reload
        end.should change(@project, :committers_count).by(1)
      end

      describe "find authors that aren't in db" do

        before(:each) do
          @importer.import
          log = File.open(File.join(Rails.root, 'spec/fixtures/files/two_committer_log.xml'))
          @importer = LogImporter.new(@project.id, log.read)
          @importer.valid?
        end

        it "should return an array of authors that don't already exist" do
          new_authors = @importer.find_new_authors
          new_authors.should be_an Array
          new_authors.size.should be 1
          new_authors[0].should eq 'new-committer'
        end
      end
    end

    describe "create commits" do

      before(:each) do
        @importer.create_committers
      end

      it "should create a new commit" do
        lambda do
          @importer.create_commits
        end.should change(Commit, :count).by(1)
      end

      it "should increase the committer's counter cache" do
        @committer = @project.committers.last
        lambda do
          @importer.create_commits
          @committer.reload
        end.should change(@committer, :commits_count).by(1)
      end

      it "should increase the project's counter cache" do
        lambda do
          @importer.create_commits
          @project.reload
        end.should change(@project, :commits_count).by(1)
      end
    end

    describe "create changes" do

      before(:each) do
        @importer.create_committers
        @importer.create_commits
      end

      it "should crate a new change" do
        lambda do
          @importer.create_changes
        end.should change(Change, :count).by(1)
      end
    end
  end

  describe "import" do

    it "should create committers, commits, and changes for a project" do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'))
      importer = LogImporter.new(Project.create(:name => 'Test Project', :user_id => 1).id, log.read)
      lambda do
        importer.import
      end.should change(Committer, :count).by(1) && change(Commit, :count).by(1) && change(Change, :count).by(1)
    end
  end

  describe "update" do

    before(:each) do
      @project_id = Project.create(:name => 'Test Project', :user_id => 1).id
      LogImporter.new(@project_id, File.open(File.join(Rails.root, 'spec/fixtures/files/simple_log.xml')).read).import
    end

    it "should update already existing committer's commits" do
      log = File.open(File.join(Rails.root, 'spec/fixtures/files/complex_log.xml'))
      importer = LogImporter.new(@project_id, log.read)
      committer = Committer.find_by_project_id(@project_id)
      commit_count = committer.commits_count
      lambda do
        importer.import
      end.should_not change(Committer, :count)
      committer.reload
      committer.commits_count.should eq commit_count + 1
    end
  end
end
