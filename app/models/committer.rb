# == Schema Information
#
# Table name: committers
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Committer < ActiveRecord::Base
  attr_accessible :name, :project_id
  
  belongs_to :project
  has_many   :commits
  
  validates :name,       :presence => true
  validates :project_id, :presence => true
end