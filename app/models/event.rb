class Event < ApplicationRecord
  require 'csv'

  has_many :attendances, dependent: :destroy
  has_many :alumni, through: :attendances
  default_scope -> {order(created_at: :desc)}
  validates :name, presence: true, uniqueness: true

  def self.import(file)
    CSV.foreach(file.path, :headers => true) do |row|
    	Event.create(row.to_hash)
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
