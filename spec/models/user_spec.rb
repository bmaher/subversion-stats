# == Schema Information
#
# Table name: users
#
#  id                       :integer    not null, primary key
#  email                    :string(255)
#  encrypted_password       :string(255)
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer
#  current_sign_in          :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  username                 :string(255)
#

require 'spec_helper'

describe User do

  before(:each) do
    @user_attr = FactoryGirl.attributes_for(:user)
  end

  it "should create a new instance given valid attributes" do
    User.create!(@user_attr)
  end

  describe "validations" do

    it "should require a username" do
      User.new(@user_attr.merge(:username => "")).should_not be_valid
    end

    it "should reject duplicate usernames" do
      old_username = User.create!(@user_attr).username
      user_with_duplicate_username = User.create(@user_attr.merge(:username => old_username))
      user_with_duplicate_username.should_not be_valid
    end

    it "should reject duplicate usernames irrespective of case" do
      old_username = @user_attr[:username]
      User.create!(@user_attr.merge(:username => old_username.upcase))
      user_with_duplicate_username = User.create(@user_attr.merge(:username => old_username))
      user_with_duplicate_username.should_not be_valid
    end
  end
end
