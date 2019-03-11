class Attendance < ApplicationRecord
  belongs_to :alumni
  belongs_to :event
  validates :alumni, presence: true
  validates :event, presence: true
end
