class Event < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :alumni, through: :attendances
  default_scope -> {order(created_at: :desc)}
  validates :name, presence: true, uniqueness: true
end
