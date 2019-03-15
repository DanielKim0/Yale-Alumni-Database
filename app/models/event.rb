class Event < ApplicationRecord
  require 'csv'

  has_many :attendances, dependent: :destroy
  has_many :alumni, through: :attendances
  default_scope -> {order(created_at: :desc)}
  validates :name, presence: true, uniqueness: true

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

  def self.search(params)
    if params[:search]
      Event.where("name like ?", "%#{params[:search]}%")
    else
      Event.all
    end
  end
end
