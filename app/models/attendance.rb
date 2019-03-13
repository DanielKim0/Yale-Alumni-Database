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
    	Attendance.create_alt(row)
    end
  end

  def self.new_alt(params)
    alumnus = Alumnus.find_by(email: params[:alumnus_email])
    event = Event.find_by(name: params[:event_name])
    self.new({alumnus_id: alumnus[:id], event_id: event[:id],
      alumnus: alumnus, event: event, description: params[:description]})
  end

  def self.create_alt(params)
    alumnus = Alumnus.find_by(email: params[:alumnus_email])
    event = Event.find_by(name: params[:event_name])
    self.create({alumnus_id: alumnus[:id], event_id: event[:id],
      alumnus: alumnus, event: event, description: params[:description]})
  end

end
