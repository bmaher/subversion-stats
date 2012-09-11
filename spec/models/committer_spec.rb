# == Schema Information
#
# Table name: committers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Committer do
  
  before(:each) do
    @project = FactoryGirl.create(:project)
    @attr = { :name => "Example committer" }
  end
  
  it "should create a new instance given valid attributes" do
    @project.committers.create!(@attr)
  end
  
  describe "validations" do
  
    it "should require a name" do
      Committer.new(@attr.merge(:name => "")).should_not be_valid
    end
    
    it "should reject a blank name" do
      Committer.new(@attr.merge(:name => "   ")).should_not be_valid
    end
  end
  
  describe "project associations" do
    
    before(:each) do
      @committer = @project.committers.create(@attr)
    end
    
    it "should have a project attribute" do
     @committer.should respond_to(:project) 
    end
    
    it "should have the correct project" do
      @committer.project_id = @project.id
    end
  end
  
  describe "commit associations" do
    
    before(:each) do
      @committer = Committer.create(@attr)
    end
    
    it "should have a commits attribute" do
      @committer.should respond_to(:commits)
    end
  end
end