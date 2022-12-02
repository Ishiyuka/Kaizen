class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :plans, dependent: :destroy
end
