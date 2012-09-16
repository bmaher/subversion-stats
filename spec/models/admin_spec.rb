# == Schema Information
#
# Table name: admins
#
#  id                       :integer    not null, primary key
#  email                    :string(255)
#  encrypted_password       :string(255)
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

describe Admin do

  before(:each) do
    @admin_attr = FactoryGirl.attributes_for(:admin)
  end

  it "should create a new instance given valid attributes" do
    Admin.create!(@admin_attr)
  end

  describe "validations" do

    it "should require a username" do
      Admin.new(@admin_attr.merge(:username => "")).should_not be_valid
    end

    it "should reject duplicate usernames" do
      old_username = Admin.create!(@admin_attr).username
      admin_with_duplicate_username = Admin.create(@admin_attr.merge(:username => old_username))
      admin_with_duplicate_username.should_not be_valid
    end

    it "should reject duplicate usernames irrespective of case" do
      old_username = @admin_attr[:username]
      Admin.create!(@admin_attr.merge(:username => old_username.upcase))
      admin_with_duplicate_username = Admin.create(@admin_attr.merge(:username => old_username))
      admin_with_duplicate_username.should_not be_valid
    end
  end
end
