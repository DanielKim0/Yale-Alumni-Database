class Attendance < ApplicationRecord
  require 'csv'

  belongs_to :alumnus
  belongs_to :event
  validates :alumnus_id, presence: true
  validates :event_id, presence: true

  attr_accessor :alumnus_email
  attr_accessor :event_name

  def self.valid_headers(file)
    attendance_params = ["alumnus_email", "event_name", "description"]

    CSV.foreach(file.path).first.each do |header|
      if !attendance_params.include? header
        return false
      end
    end
    return true
  end

  def self.import(file)
    file_count = 0
    if file && file.content_type == "text/csv" && valid_headers(file)
      CSV.foreach(file.path, :headers => true) do |row|
        begin
          valid = self.new_alt(row.to_hash).valid?
        rescue NoMethodError
          file_count += 1
        rescue PG::UniqueViolation
          file_count += 1
        else
          if valid
            begin
              Attendance.create_alt(row.to_hash)
            rescue ActiveRecord::RecordNotUnique
              file_count += 1
            end
          else
            file_count += 1
          end
        end
      end
      return file_count
    else
      return -1
    end
  end

  def self.to_csv
    attributes = ["alumnus_email", "event_name", "description"]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      Attendance.all.each do |attendance|
        csv << [Alumnus.find_by(id: attendance.alumnus_id).email, Event.find_by(id: attendance.event_id).name, attendance.description]
      end
    end
  end

  def self.new_alt(params)
    alumnus = Alumnus.find_by(email: params["alumnus_email"])
    event = Event.find_by(name: params["event_name"])
    if !(params.has_key? :description)
      params[:description] = ""
    end
    return self.new({alumnus_id: alumnus[:id], event_id: event[:id],
      alumnus: alumnus, event: event, description: params[:description]})
  end

  def self.create_alt(params)
    alumnus = Alumnus.find_by(email: params["alumnus_email"])
    event = Event.find_by(name: params["event_name"])
    if !(params.has_key? :description)
      params[:description] = ""
    end
    return self.create({alumnus_id: alumnus[:id], event_id: event[:id],
      alumnus: alumnus, event: event, description: params[:description]})
  end

end
