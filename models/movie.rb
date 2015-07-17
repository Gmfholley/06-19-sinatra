class Movie < ActiveRecord::Base
  belongs_to :rating
  belongs_to :studio
  
  has_and_belongs_to_many :locations, through: :location_times
  has_and_belongs_to_many :time_slots, through: :location_times  
  
  validates :name, presence: true
  validates :description, presence: true
  validate :length_greater_than_zero
  

  validates :length, presence: true, numericality: {only_integer: true}
  
  validates :studio, presence: true
  validates :rating, presence: true
  
  
  # if the number of seats is zero or below, it adds an error
  #
  # returns errors Array
  def length_greater_than_zero
    if length <= 0
      errors.add(:length, "must be greater than zero.")
    end
    errors
  end

  
end