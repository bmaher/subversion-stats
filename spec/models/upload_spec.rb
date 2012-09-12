require 'spec_helper'

describe Upload do
  
  before(:each) do
    @attr = { :project_name => "Example Project",
              :log_file => "Test Log" }
  end
  
  it "should create a new instance given valid attributes" do
    Upload.new(@attr)
  end
  
  describe "validations" do
  
    it "should require a project name" do
      Upload.new(@attr.merge(:project_name => "")).should_not be_valid
    end
    
    it "should reject a blank project name" do
      Upload.new(@attr.merge(:project_name => "   ")).should_not be_valid
    end
    
    it "should require a log file" do
      Upload.new(@attr.merge(:log_file => "")).should_not be_valid
    end
    
    it "should reject a blank log file" do
      Upload.new(@attr.merge(:log_file => "   ")).should_not be_valid
    end
  end
end