require 'spec_helper'

describe "Users" do

  describe "create user" do
    
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit new_user_path
          fill_in "Username", :with => ""
          click_button
          response.should render_template("users/new")
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit new_user_path
          fill_in "Username", :with => "Test User"
          click_button
          response.should have_selector("p", :content => "User was successfully created.")
          response.should render_template("users/show")
        end.should change(User, :count).by(1)
      end
    end 
  end
end