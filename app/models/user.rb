# == Schema Information
#
# Table name: users
#
#  id                       :integer    not null, primary key
#  email                    :string(255)
#  encrypted_password       :string(255)
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer
#  current_sign_in          :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  username                 :string(255)
#  roles_mask               :integer
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :projects

  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :roles
  validates :username, :uniqueness => true,
                       :presence => true

  ROLES = %w[admin project_owner]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def has_role?(role)
    roles.include?(role.to_s)
  end
end
