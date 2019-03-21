class Event < ApplicationRecord
  require 'csv'

  has_many :attendances, dependent: :destroy
  has_many :alumni, through: :attendances
  default_scope -> {order(created_at: :desc)}
  validates :name, presence: true, uniqueness: true
  validates :month, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 12, allow_nil: true}

  def self.valid_headers(file)
    event_params = ["name", "month", "year", "description", "CLY_sponsored", "location"]

    CSV.foreach(file.path).first.each do |header|
      if !event_params.include? header
        return false
      end
    end
    return true
  end

  def self.import(file)
    file_count = 0
    if file && file.content_type == "text/csv" && valid_headers(file)
      CSV.foreach(file.path, :headers => true) do |row|
        valid = Event.new(row.to_hash).valid?
        if valid
          Event.create(row.to_hash)
        else
          file_count += 1
        end
      end
      return file_count
    else
      return -1
    end
  end

  def self.to_csv
    attributes = ["name", "month", "year", "description", "CLY_sponsored", "location"]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      Event.all.each do |event|
        csv << event.attributes.values_at(*attributes)
      end
    end
  end

  def self.search(params)
    if params[:search]
      Event.basic_search(params[:search])
    else
      Event.all
    end
  end
end
