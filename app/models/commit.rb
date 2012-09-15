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
#

class Commit < ActiveRecord::Base
  attr_accessible :revision, :committer_id, :datetime, :message
  
  belongs_to  :committer
  has_many    :changes
   
  validates :revision,       :presence => true
  validates :committer_id,   :presence => true
  validates :datetime,       :presence => true
  validates :message,        :length =>  { :minimum => 0 },
                             :allow_blank => true
end