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
  
  # returns all Locations with tickets greater than the number of tickets
  #
  # num_tickets    - Integer of the number of tickets sold
  #
  # returns an Array of LocationTime objects
  def self.where_tickets_greater_than(num_tickets)
    LocationTime.where_match("num_tickets_sold", num_tickets, ">")
  end
  
  # returns Array of objects of the sold out or not sold out LocationTimes
  #
  # returns an Array
  def self.where_sold_out(sold_out=true)
    if sold_out
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN 
     locations location ON location.id = locationtime.location_id WHERE location.num_seats <= 
     locationtime.num_tickets_sold;"))
   else
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN 
     locations location ON location.id = locationtime.location_id WHERE location.num_seats > 
     locationtime.num_tickets_sold;"))
   end
  end
  
end