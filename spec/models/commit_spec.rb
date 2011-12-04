require 'spec_helper'

describe Commit do
  
  before(:each) do
    
    @user = User.create!(:username => "Test User")
    
    @attr = { :revision => 1234,
              :user_id  => @user.id,
              :datetime => "01/01/2011",
              :message  => "my commit" }
  end
  
  it "should create a new instance given valid attributes" do
    Commit.create!(@attr)
  end
  
  describe "validations" do
    
    it "should require a revision" do
      Commit.new(@attr.merge(:revision => "")).should_not be_valid
    end
    
    it "should require a user_id" do
      Commit.new(@attr.merge(:user_id => "")).should_not be_valid
    end
    
    it "should require a datetime" do
      Commit.new(@attr.merge(:datetime => "")).should_not be_valid
    end
    
    it "should require a message" do
      Commit.new(@attr.merge(:message => "")).should_not be_valid
    end
  end
  
  describe "user associations" do
    
    before(:each) do
      @commit = @user.commits.create(@attr)
    end
    
    it "should have a user attribute" do
      @commit.should respond_to(:user)
    end
    
    it "should have the correct user" do
      @commit.user_id.should == @user.id
      @commit.user.should == @user
    end
  end
  
  describe "change association" do
    
    before(:each) do
      @commit = @user.commits.create(@attr)
    end
    
    it "should have a change attribute" do
      @commit.should respond_to(:change)
    end
  end  
end