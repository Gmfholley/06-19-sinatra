class Movie < ActiveRecord::Base
  belongs_to :rating
  belongs_to :studio
  
  validates :name, presence: true
  validates :description, presence: true
  
  # TODO - look up how to say length must be an integer greater than 0
  validates :length, presence: true, numericality: {integer: true, greater_than_zero: true}
  
  validates :studio, presence: true
  validates :rating, presence: true


  
end