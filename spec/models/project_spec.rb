require 'spec_helper'

describe Project do
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @attr = { :name        => "Example Project",
              :description => "Example Description" }
  end
  
  it "should create a new instance given valid attributes" do
    Project.create!(@attr)
  end
  
  describe "validations" do
  
    it "should require a name" do
      Project.new(@attr.merge(:name => "")).should_not be_valid
    end
    
    it "should reject a blank name" do
      Project.new(@attr.merge(:name => "   ")).should_not be_valid
    end
    
    it "should require a description" do
      Project.new(@attr.merge(:description => "")).should_not be_valid
    end
    
    it "should reject a blank description" do
      Project.new(@attr.merge(:description => "   ")).should_not be_valid
    end
  end
  
  describe "user associations" do
    
    before(:each) do
      @project = Project.create(@attr)
    end
    
    it "should have a users attribute" do
      @project.should respond_to(:users)
    end
  end
end
