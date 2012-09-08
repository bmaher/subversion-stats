require 'spec_helper'

describe "Projects" do

  describe "create project" do
    
    describe "failure" do
      it "should not make a new project" do
        lambda do
          visit new_project_path
          fill_in "Name", :with => ""
          fill_in "Description", :with => ""
          click_button
          response.should render_template("projects/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Project, :count)
      end
    end
    
    describe "success" do
      it "should make a new project" do
        lambda do
          visit new_project_path
          fill_in "Name", :with => "Test Project"
          fill_in "Description", :with => "Test Description"
          click_button
          response.should have_selector("p", :content => "Project was successfully created.")
          response.should render_template("projects/show")
        end.should change(Project, :count).by(1)
      end
    end 
  end
end