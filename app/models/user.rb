# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessible :name, :project_id
  
  belongs_to :project
  has_many   :commits
  
  validates :name, :presence => true
end
