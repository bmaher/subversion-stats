require 'spec_helper'

describe "Commits" do

  describe "create commit" do
    
    describe "failure" do
      it "should not make a new commit" do
        lambda do
          visit new_commit_path
          fill_in "Revision", :with => ""
          fill_in "committer", :with => ""
          fill_in "Datetime", :with => ""
          fill_in "Message", :with => ""                              
          click_button
          response.should render_template("commits/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Commit, :count)
      end
    end
    
    describe "success" do
      it "should make a new commit" do
        lambda do
          committer = FactoryGirl.create(:committer)
          visit new_commit_path
          fill_in "Revision", :with => 1234
          fill_in "committer", :with => committer.id
          fill_in "Datetime", :with => "01/01/2011"
          fill_in "Message", :with => "Message"
          click_button
          response.should have_selector("p", :content => "Commit was successfully created.")
          response.should render_template("commits/show")
        end.should change(Commit, :count).by(1)
      end
    end 
  end
end