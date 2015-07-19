class Location < ActiveRecord::Base
  has_many :location_times
  has_many :movies, through: :location_times
  has_many :time_slots, through: :location_times
  
  
  validates :name, presence: true
  validates :num_seats, presence: true, numericality: {only_integer: true}
  validates :num_staff, presence: true, numericality: {only_integer: true}
  validates :num_time_slots, presence: true, numericality: {only_integer: true}
  
  validate :num_seats_greater_than_zero, :num_staff_greater_than_zero, :num_time_slots_greater_than_zero_and_less_than_max_num
  
  # if the number of seats is zero or below, it adds an error
  #
  # returns errors Array
  def num_seats_greater_than_zero
    if num_seats <= 0
      errors.add(:num_seats, "must be greater than zero.")
    end
    errors
  end
  
  # returns an Array of Locations that are available (ie - can be booked)
  #
  # returns Array
  def self.where_available(available=true)
    if available
      location_hashes = ActiveRecord::Base.connection.execute("SELECT COUNT(*) Loc, *  FROM location_times OUTER JOIN 
      locations ON location_times.location_id = locations.id GROUP BY locations.id, locations.name HAVING 
      COUNT(*) < locations.num_time_slots;")
    else
      location_hashes = ActiveRecord::Base.connection.execute("SELECT COUNT(*) Loc, *  FROM location_times INNER JOIN 
      locations ON location_times.location_id = locations.id GROUP BY locations.id, locations.name HAVING  
      COUNT(*) >= locations.num_time_slots;")
   end 
  as_objects(location_hashes)
  end
  
  # returns an Array of Objects from hashes
  #
  # array_of_hashes - Array of Hashes
  #
  # returns an Array of Objects
  def as_objects(array_of_hashes)
    objects = []
    array_of_hashes.each do |hash|
      objects << Location.new(hash)
    end
    objects
  end
  
  # if the number of staff is zero or below, it adds an error
  #
  # returns errors Array
  def num_staff_greater_than_zero
    if num_staff <= 0
      errors.add(:num_staff, "must be greater than zero.")
    end
    errors
  end
  
  # if the number of seats is below zero, it adds an error
  #
  # returns errors Array
  def num_time_slots_greater_than_zero_and_less_than_max_num
    if num_time_slots <= 0
      errors.add(:num_time_slots, "must be greater than zero.")
    elsif num_time_slots > Location.max_num_time_slots
      errors.add(:num_time_slots, "must be less than or equal to the number of possible time slots.")
    end
    errors
  end
  
  # returns a Boolean if this location has available time slots
  #    
  # returns Boolean
  def has_available_time_slot?
    self.location_times.length < num_time_slots
  end
  
  # returns Integer of the maximum number of time slots allowed
  #
  # returns Integer
  def self.max_num_time_slots
    ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM time_slots;").first[0]
  end  
  
end