class Event < ApplicationRecord
  has_many :attendances
  has_many :alumni, through :attendances
  default_scope -> {order(created_at: :desc)}
  validates :name, presence: true
end
