class TimeSlot < ActiveRecord::Base
  has_many :location_times
  has_many :movies, through: :location_times
  has_many :locations, through: :location_times
  
  
  validates :name, presence: true
  
  # returns the total staff needed for a particular time slot
  #
  # returns an Integer
  def num_staff_needed
    sum = 0
    query_string = "SELECT SUM(locations.num_staff) FROM location_times INNER JOIN time_slots ON location_times.time_slot_id = time_slots.id INNER JOIN locations ON location_times.location_id = locations.id WHERE time_slots.id = #{@id} GROUP BY location_times.location_id;"
    staff_array = ActiveRecord::Base.connection.execute(query_string)
    staff_array.each do |hash|
      sum += hash["SUM(locations.num_staff)"]
    end
    sum
  end
  
end