class Attendance < ApplicationRecord
  belongs_to :alumni
  belongs_to :group
end
