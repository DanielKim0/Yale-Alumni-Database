class Alumnus < ApplicationRecord
  require 'csv'

  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  default_scope -> {order(created_at: :desc)}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }

  def self.valid_headers(file)
    alumnus_params = ["name", "email", "phone", "location",
      "college", "yale_degree", "yale_degree_year", "other_degrees", "linkedin",
      "employer", "employed_field", "recommender"]

    data = CSV.new(file).read
    data[0].each do |header|
      if !alumnus_params.include? header
        return false
      end
    end
    return true
  end

  def self.import(file)
    if file && file.content_type == "text/csv" && valid_headers(file)
      CSV.foreach(file.path, :headers => true) do |row|
        Alumnus.create(row.to_hash)
      end
      return true
    else
      return false
    end
  end

  def self.search(params)
    if params[:search]
      Alumnus.where("name like ?", "%#{params[:search]}%")
    else
      Alumnus.all
    end
  end
end
