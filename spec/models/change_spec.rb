# == Schema Information
#
# Table name: changes
#
#  id           :integer         not null, primary key
#  revision     :integer
#  status       :string(255)
#  project_root :string(255)
#  filepath     :string(255)
#  fullpath     :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  commit_id    :integer
#

require 'spec_helper'

describe Change do
  
  before(:each) do
    @commit = FactoryGirl.create(:commit)
      
    @attr = { :revision     => @commit.revision,
              :status       => "A",
              :project_root => "myProject",
              :filepath     => "/myProject/trunk/",
              :fullpath     => "http://svn.myServer.com/svn/myProject/trunk/myFile.txt" }
  end
  
  it "should create a new instance given valid attributes" do
    @commit.changes.create!(@attr)
  end
  
  describe "validations" do
    
    it "should require a revision" do
      Change.new(@attr.merge(:revision => "")).should_not be_valid
    end
    
    it "should require a status" do
      Change.new(@attr.merge(:status => "")).should_not be_valid
    end
    
    it "should require a project root" do
      Change.new(@attr.merge(:project_root => "")).should_not be_valid
    end
    
    it "should require a filepath" do
      Change.new(@attr.merge(:filepath => "")).should_not be_valid
    end
    
    it "should require a fullpath" do
      Change.new(@attr.merge(:fullpath => "")).should_not be_valid
    end
  end
end