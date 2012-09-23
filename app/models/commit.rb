# == Schema Information
#
# Table name: commits
#
#  id         :integer         not null, primary key
#  revision   :integer
#  committer_id    :integer
#  datetime   :string(255)
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  project_id :integer
#

class Commit < ActiveRecord::Base
  attr_accessible :revision, :committer_id, :datetime, :message, :project_id

  belongs_to  :project, :counter_cache => true
  belongs_to  :committer, :counter_cache => true
  has_many    :changes, :dependent => :destroy
   
  validates :revision,       :presence => true
  validates :committer_id,   :presence => true
  validates :datetime,       :presence => true
  validates :message,        :length =>  { :minimum => 0 },
                             :allow_blank => true
end