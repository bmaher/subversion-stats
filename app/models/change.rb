class Change < ActiveRecord::Base
end

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

