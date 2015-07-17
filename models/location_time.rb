class LocationTime < ActiveRecord::Base
  
  belongs_to :movie
  belongs_to :location
  belongs_to :time_slot
  
  validates :movie, presence: true
  validates :location, presence: true
  validates :time_slot, presence: true
  
  validates :num_tickets_sold, presence: true, numericality: {only_integer: true}
  validate :num_tickets_sold_greater_than_zero_and_less_than_max_num
  
  
  # if the number of seats is below zero, it adds an error
  #
  # returns errors Array
  def num_tickets_sold_greater_than_zero_and_less_than_max_num
    if num_tickets_sold < 0
      errors.add(:num_tickets_sold, "must be greater than or equal to zero.")
    elsif num_tickets_sold > max_num_seats
      errors.add(:num_tickets_sold, "must be less than or equal to the number of possible seats.")
    end
    errors
  end
  
  # returns the maximum number of seats for this location
  #
  # returns an Integer
  def max_num_seats
    Location.find(location_id).num_seats
  end
  
  # returns whether tickets are sold out for the location
  #
  # returns Boolean
  def sold_out?
    num_tickets_sold >= max_num_seats
  end
  
  # returns how many tickets remain at this location
  #
  # returns Integer
  def tickets_remaining
    if !max_num_seats.blank?
       max_num_seats - num_tickets_sold
    else
      0
    end
  end
  
end