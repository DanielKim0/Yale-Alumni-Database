class Attendance < ApplicationRecord
  belongs_to :alumni
  belongs_to :event
  validates :alumnus_id, presence: true
  validates :event_id, presence: true
end
