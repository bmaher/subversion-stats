require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :username => "Example User" }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  describe "validations" do
  
    it "should require a username" do
      User.new(@attr.merge(:username => "")).should_not be_valid
    end
    
    it "should reject a blank username" do
      User.new(@attr.merge(:username => "   ")).should_not be_valid
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

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  username   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

