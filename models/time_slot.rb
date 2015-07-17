class TimeSlot < ActiveRecord::Base
  has_and_belongs_to_many :movies, through: :location_times
  has_and_belongs_to_many :locations, through: :location_times
  
  
  validates :name, presence: true
  
  # returns the total staff needed for a particular time slot
  #
  # returns an Integer
  def num_staff_needed
    sum = 0
    query_string = "SELECT SUM(locations.num_staff) FROM locationtimes INNER JOIN timeslots ON locationtimes.timeslot_id = timeslots.id INNER JOIN locations ON locationtimes.location_id = locations.id WHERE timeslots.id = #{@id} GROUP BY locationtimes.location_id;"
    staff_array = ActiveRecord::Base.connection.execute(query_string)
    staff_array.each do |hash|
      sum += hash["SUM(locations.num_staff)"]
    end
    sum
  end
  
end