class Team < ApplicationRecord
  has_many :assigns, dependent: :destroy
  has_many :members, through: :assigns, source: :user
  has_many :issues, dependent: :destroy
  has_many :plans, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  mount_uploader :team_image, ImageUploader
  def invite_member(user)
    assigns.create(user: user)
  end
end
