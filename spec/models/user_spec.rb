# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe User do
  
  before(:each) do
    @project = FactoryGirl.create(:project)
    @attr = { :name => "Example User" }
  end
  
  it "should create a new instance given valid attributes" do
    @project.users.create!(@attr)
  end
  
  describe "validations" do
  
    it "should require a name" do
      User.new(@attr.merge(:name => "")).should_not be_valid
    end
    
    it "should reject a blank name" do
      User.new(@attr.merge(:name => "   ")).should_not be_valid
    end
  end
  
  describe "project associations" do
    
    before(:each) do
      @user = @project.users.create(@attr)
    end
    
    it "should have a project attribute" do
     @user.should respond_to(:project) 
    end
    
    it "should have the correct project" do
      @user.project_id = @project.id
    end
  end
  
  describe "commit associations" do
    
    before(:each) do
      @user = User.create(@attr)
    end
    
    it "should have a commits attribute" do
      @user.should respond_to(:commits)
    end
  end
end