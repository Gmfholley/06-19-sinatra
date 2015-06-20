require_relative 'database_connector.rb'

class TimeSlot
  include DatabaseConnector

  attr_reader :id, :errors
  attr_accessor :time_slot

  
  def initialize(args={})
    @id = args["id"] || ""
    @time_slot = args[:time_slot] || args["time_slot"]
  end

  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    LocationTime.where_match("timeslot_id", id, "==")
  end
  
  # returns self as string
  #
  # returns String
  def to_s
    "id: #{id}\t\ttime slot: #{time_slot}"
  end
  
  # returns the total staff needed for a particular time slot
  #
  # returns an Integer
  def num_staff_needed
    sum = 0
    
    staff_array = CONNECTION.execute("SELECT SUM(locations.num_staff) FROM locationtimes INNER JOIN timeslots ON locationtimes.timeslot_id = timeslots.id INNER JOIN locations ON locationtimes.location_id = locations.id WHERE timeslots.id = #{id} GROUP BY locationtimes.location_id;")
    staff_array.each do |hash|
      sum += hash["SUM(locations.num_staff)"]
    end
    sum
  end
  
  # returns Boolean if ok to delete
  #
  # id - Integer of the id to delete
  #
  # returns Boolean
  def self.ok_to_delete?(id)
    if LocationTime.where_match("timeslot_id", id, "==").length > 0
        false
    else
        true
    end
  end
  
  # returns Boolean if data is valid
  #
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    if time_slot.to_s.empty?
      @errors << {message: "TimeSlot slot cannot be empty.", variable: "time_slot"}
    end
    
    @errors.empty?
  end
  
  
end