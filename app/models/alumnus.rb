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

  def self.import(file)
    CSV.foreach(file.path, :headers => true) do |row|
    	Alumnus.create(row.to_hash)
    end
  end

end
