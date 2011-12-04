# == Schema Information
#
# Table name: changes
#
#  id           :integer         not null, primary key
#  revision     :integer
#  status       :string(255)
#  project_root :string(255)
#  filepath     :string(255)
#  fullpath     :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Change < ActiveRecord::Base
  attr_accessible :revision, :status, :project_root, :filepath, :fullpath
  
  belongs_to :commit
  
  validates :revision,      :presence => true  
  validates :status,        :presence => true
  validates :project_root,  :presence => true
  validates :filepath,      :presence => true
  validates :fullpath,       :presence => true
end