require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Projects" do

  describe "create project" do

    before(:each) do
      user = FactoryGirl.create(:user)
      login_as(user)
    end

    describe "failure" do
      it "should not make a new project" do
        lambda do
          visit new_project_path
          fill_in "Name", :with => ""
          click_button
          response.should render_template("projects/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Project, :count)
      end
    end
    
    describe "success" do

      describe "without log file" do

        it "should make a new project" do
          lambda do
            visit new_project_path
            fill_in "Name", :with => "Test Project"
            click_button
            response.should have_selector("p", :content => "Project was successfully created.")
            response.should render_template("projects/show")
          end.should change(Project, :count).by(1)
        end
      end

      describe "with log file" do

        describe "manual upload" do

          it "should make a new project and import the log file" do
            lambda do
              visit new_project_path
              fill_in "Name", :with => "Test Project"
              attach_file('project_log_file', File.join(Rails.root, 'spec/fixtures/files/simple_log.xml'), 'text/xml')
              click_button
              response.should have_selector("p", :content => "Project is being imported.")
              response.should render_template("projects/show")
            end.should change(Project, :count).by(1) && change(ImportWorker.jobs, :size).by(1)
          end
        end

        describe "http upload" do

          it "should make a new project and import the log file" do
            lambda do
              visit new_project_path
              fill_in "Name",           :with => "Test Project"
              fill_in "Repository Url", :with => "localhost"
              fill_in "Username",       :with => "user"
              fill_in "Password",       :with => "password"
              fill_in "Revision from",  :with => "HEAD"
              fill_in "Revision to",    :with => "1000"
              click_button
              response.should have_selector("p", :content => "Project is being imported.")
              response.should render_template("projects/show")
            end.should change(Project, :count).by(1) && change(FetchWorker.jobs, :size).by(1)
          end
        end
      end
    end 
  end

  describe "edit project" do

    before(:each) do
      user = FactoryGirl.create(:user, :roles => %w[project_owner])
      login_as(user)
      @project = FactoryGirl.create(:project, :user => user)
    end

    describe "failure" do
      it "should not update the project" do
        visit edit_project_path @project.id
        fill_in "Name", :with => ""
        click_button
        response.should render_template("projects/edit")
        response.should have_selector("div#error_explanation")
      end
    end

    describe "success" do

      describe "without log file" do

        it "should update the project" do
          visit edit_project_path @project.id
          new_name = "New Project Name"
          fill_in "Name", :with => new_name
          click_button
          response.should render_template("projects/show")
          response.should have_selector("p", :content => "Project was successfully updated.")
          response.should have_selector("h1", :content => "Project: #{new_name}")
        end
      end

      describe "with log file" do

        it "should update the project and import the log file" do
          lambda do
            visit edit_project_path @project.id
            new_name = "New Project Name"
            fill_in "Name", :with => new_name
            attach_file('project_log_file', File.join(Rails.root, 'spec/fixtures/files/complex_log.xml'), 'text/xml')
            click_button
            response.should render_template("projects/show")
            response.should have_selector("p", :content => "Project is being updated.")
            response.should have_selector("h1", :content => "Project: #{new_name}")
          end.should change(ImportWorker.jobs, :size).by(1)
        end
      end
    end
  end
end