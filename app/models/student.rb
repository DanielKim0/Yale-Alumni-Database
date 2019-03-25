class Student < ApplicationRecord
  require 'csv'

  default_scope -> {order(created_at: :desc)}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 },
                  format: { with: VALID_EMAIL_REGEX },
                  uniqueness: { case_sensitive: false }

  def self.valid_headers(file)
    student_params = ["name", "email", "year"]

    CSV.foreach(file.path).first.each do |header|
      if !student_params.include? header
        return false
      end
    end
    return true
  end

  def self.import(file)
    file_count = 0
    if file && file.content_type == "text/csv" && valid_headers(file)
      CSV.foreach(file.path, :headers => true) do |row|
        valid = Student.new(row.to_hash).valid?
        if valid
          Student.create(row.to_hash)
        else
          Student.create(row.to_hash)
          file_count += 1
        end
      end
      return file_count
    else
      return -1
    end
  end

  def self.to_csv
    attributes = ["name", "email", "year"]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      Student.all.each do |student|
        csv << student.attributes.values_at(*attributes)
      end
    end
  end

  def self.search(params)
    if params[:search]
      Student.basic_search(params[:search])
    else
      Student.all
    end
  end
end
