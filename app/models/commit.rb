# == Schema Information
#
# Table name: commits
#
#  id         :integer         not null, primary key
#  revision   :integer
#  user_id    :integer
#  datetime   :string(255)
#  message    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Commit < ActiveRecord::Base
  attr_accessible :revision, :datetime, :message
  
  belongs_to  :user
  has_many    :changes
   
  validates :revision,  :presence => true
  validates :user_id,   :presence => true
  validates :datetime,  :presence => true
  validates :message,   :presence => true
end