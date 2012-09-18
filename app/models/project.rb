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
  attr_accessible :name, :user_id

  belongs_to :user
  has_many :committers, :dependent => :destroy

  validates :name,    :presence => true
  validates :user_id, :presence => true
end
