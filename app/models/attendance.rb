class Attendance < ApplicationRecord
  require 'csv'

  belongs_to :alumnus
  belongs_to :event
  validates :alumnus_id, presence: true
  validates :event_id, presence: true

  attr_accessor :alumnus_email
  attr_accessor :event_name

  def self.import(file)
    CSV.foreach(file.path, :headers => true) do |row|
      email, name, desc = row
      alumnus = Alumnus.find_by("email = email")
      event = Event.find_by("name = name")
    	Attendance.create({ alumnus_id: alumnus[:id], event_id: event[:id], alumnus: alumnus, event: event, description: desc })
    end
  end

end
