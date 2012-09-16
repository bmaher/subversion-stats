# == Schema Information
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Project do
  
  before(:each) do
    @committer = FactoryGirl.create(:committer)
    @attr = { :name => "Example Project" }
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
  end
  
  describe "committer associations" do
    
    before(:each) do
      @project = Project.create(@attr)
    end
    
    it "should have a committers attribute" do
      @project.should respond_to(:committers)
    end
  end
end
