class Commit < ActiveRecord::Base
end

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

