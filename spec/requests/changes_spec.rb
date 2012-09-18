require 'spec_helper'

include Warden::Test::Helpers
Warden.test_mode!

describe "Changes" do

  before(:each) do
    user = FactoryGirl.create(:user, :roles => %w[admin])
    login_as(user, :scope => :user)
  end

  describe "create change" do
    
    describe "failure" do
      it "should not make a new change" do
        lambda do
          visit new_change_path
          fill_in "Revision", :with => ""
          fill_in "Commit", :with => ""
          fill_in "Status", :with => ""
          fill_in "Project Root", :with => ""
          fill_in "Filepath", :with => ""
          fill_in "Fullpath", :with => ""
          click_button
          response.should render_template("changes/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Change, :count)
      end
    end
    
    describe "success" do
      it "should make a new change" do
        lambda do
          visit new_change_path
          fill_in "Revision", :with => 1
          fill_in "Commit", :with => 1
          fill_in "Status", :with => "A"
          fill_in "Project Root", :with => "/target"
          fill_in "Filepath", :with => "/target/src/main"
          fill_in "Fullpath", :with => "/target/src/main/file.txt"
          click_button
          response.should have_selector("p", :content => "Change was successfully created.")
          response.should render_template("changes/show")
        end.should change(Change, :count).by(1)
      end
    end 
  end
end