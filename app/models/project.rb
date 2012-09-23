# == Schema Information
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#

class Project < ActiveRecord::Base
  attr_accessor :log_file
  attr_accessible :name, :user_id, :log_file

  belongs_to :user
  has_many :committers, :dependent => :destroy
  has_many :commits

  validates :name,    :presence => true
  validates :user_id, :presence => true
end
