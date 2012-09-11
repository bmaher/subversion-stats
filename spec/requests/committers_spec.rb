require 'spec_helper'

describe "Committers" do

  describe "create committer" do
    
    describe "failure" do
      it "should not make a new committer" do
        lambda do
          visit new_committer_path
          fill_in "Name", :with => ""
          click_button
          response.should render_template("committers/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(Committer, :count)
      end
    end
    
    describe "success" do
      it "should make a new committer" do
        lambda do
          visit new_committer_path
          fill_in "Name", :with => "Test committer"
          click_button
          response.should have_selector("p", :content => "committer was successfully created.")
          response.should render_template("committers/show")
        end.should change(Committer, :count).by(1)
      end
    end 
  end
end