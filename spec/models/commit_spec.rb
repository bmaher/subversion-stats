# == Schema Information
#
# Table name: commits
#
#  id         :integer         not null, primary key
#  revision   :integer
#  committer_id    :integer
#  datetime   :string(255)
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Commit do
  
  before(:each) do
    
    @committer = FactoryGirl.create(:committer)
    
    @attr = { :revision => 1234,
              :datetime => "01/01/2011",
              :message  => "my commit" }
  end
  
  it "should create a new instance given valid attributes" do
    @committer.commits.create!(@attr)
  end
  
  describe "validations" do
    
    it "should require a revision" do
      Commit.new(@attr.merge(:revision => "")).should_not be_valid
    end
    
    it "should require a committer_id" do
      Commit.new(@attr.merge(:committer_id => "")).should_not be_valid
    end
    
    it "should require a datetime" do
      Commit.new(@attr.merge(:datetime => "")).should_not be_valid
    end
    
    it "should require a message" do
      Commit.new(@attr.merge(:message => "")).should_not be_valid
    end
  end
  
  describe "committer associations" do
    
    before(:each) do
      @commit = @committer.commits.create(@attr)
    end
    
    it "should have a committer attribute" do
      @commit.should respond_to(:committer)
    end
    
    it "should have the correct committer" do
      @commit.committer_id.should == @committer.id
      @commit.committer.should == @committer
    end
  end
  
  describe "change association" do
    
    before(:each) do
      @commit = @committer.commits.create(@attr)
    end
    
    it "should have a change attribute" do
      @commit.should respond_to(:changes)
    end
  end  
end