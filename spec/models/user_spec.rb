require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :username => "Example User" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a username" do
    User.new(@attr.merge(:username => "")).should_not be_valid
  end
  
end
