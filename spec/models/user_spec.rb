require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :username => "Example User" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
end
