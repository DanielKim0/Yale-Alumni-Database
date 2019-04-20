class Alumnus < ApplicationRecord
  require 'csv'

  has_many :attendances, dependent: :destroy
  has_many :events, through: :attendances
  default_scope -> {order(created_at: :desc)}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }

  def self.valid_headers(file)
    alumnus_params = ["first_name", "last_name", "email", "phone",
      "location", "college", "yale_degree", "other_degrees", "linkedin",
      "employer", "employed_field", "recommender", "description"]

    CSV.foreach(file.path).first.each do |header|
      if !alumnus_params.include? header
        return false
      end
    end
    return true
  end

  def self.import(file)
    file_count = 0
    if file && file.content_type == "text/csv" && valid_headers(file)
      CSV.foreach(file.path, :headers => true) do |row|
        valid = Alumnus.new(row.to_hash).valid?
        if valid
          Alumnus.create(row.to_hash)
        else
          Alumnus.create(row.to_hash)
          file_count += 1
        end
      end
      return file_count
    else
      return -1
    end
  end

  def self.to_csv
    attributes = ["first_name", "last_name", "email", "phone", "location",
      "college", "yale_degree", "other_degrees", "linkedin",
      "employer", "employed_field", "recommender", "description"]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      Alumnus.all.each do |alumnus|
        csv << alumnus.attributes.values_at(*attributes)
      end
    end
  end

  def self.search(params)
    if params[:search]
      Alumnus.basic_search(params[:search])
    else
      Alumnus.all
    end
  end
end
