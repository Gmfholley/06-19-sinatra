require_relative 'database_connector.rb'

# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class LocationTime
  include DatabaseConnector
  
  attr_accessor :movie_id, :num_tickets_sold
  attr_reader :location_id, :timeslot_id, :errors
  # initializes object
  #
  # args -      Options Hash
  #             id                - Integer of the ID number of record in the database
  #             location_id       - Integer of the location_id in the locations table
  #             timeslot_id       - Integer of the timeslot_id in timeslots table
  #             movie_id          - Integer of the movie_id in movies table
  #             num_tickets_sold  - Integer of the number of tickets sold for this time slot
  #
  def initialize(args={})
    @location_id = args[:location_id] || args["location_id"]
    @timeslot_id = args[:timeslot_id] || args["timeslot_id"]
    @movie_id = args[:movie_id] || args["movie_id"]
    @num_tickets_sold = args["num_tickets_sold"] || 0
  end
  
  # returns the String representation of the time slot
  #
  # returns String
  def to_s
    "location:\t#{location}\t\ttimeslot:\t#{timeslot}\t\tmovie:\t#{movie}"
  end
  
  # returns the movie's name
  #
  # returns String
  def movie
    m = Movie.create_from_database(movie_id)
    m.name
  end
  
  # returns the time slot in time
  #
  # returns Integer
  def timeslot
    t = Time.create_from_database(timeslot_id)
    t.time_slot
  end
  
  # returns the location name for this time slot
  #
  # returns String
  def location
    l = Location.create_from_database(location_id)
    l.name
  end
  
  # returns whether tickets are sold out for the location
  #
  # returns Boolean
  def sold_out?
    l = Location.create_from_database(location_id)
    l.num_seats == num_tickets_sold
  end
  
  # returns how many tickets remain at this location
  #
  # returns Integer
  def tickets_remaining
    l = Location.create_from_database(location_id)
    l.num_seats - num_tickets_sold
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_location
    LocationTime.where_match("location_id", @location_id, "==")
  end


  # returns Boolean if objects are valid
  #
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    # check the description exists and is not empty
    if timeslot_id.to_s.empty?
      @errors << {message: "Timeslot id cannot be empty.", variable: "timeslot_id"}
    elsif timeslot.blank?
      @errors << {message: "Timeslot id must be a member of the times table.", variable: "timeslot_id"}
    end      
    
    # check the description exists and is not empty
    if location_id.to_s.empty?
      @errors << {message: "Location id cannot be empty.", variable: "location_id"}
    elsif location.blank?
      @errors << {message: "Location id must be a member of the locations table.", variable: "location_id"}
    end
    
    # check the description exists and is not empty
    if movie_id.to_s.empty?
      @errors << {message: "Movie id cannot be empty.", variable: "movie_id"}
    elsif movie.blank?
      @errors << {message: "Movie id must be a member of the movies table.", variable: "movie_id"}
    end
    
    # checks the number of time slots
    if num_tickets_sold.to_s.empty?
      @errors << {message: "Num_tickets_sold cannot be empty.", variable: "num_tickets_sold"}
    elsif num_tickets_sold.is_a? Integer
      if num_tickets_sold < 0
        @errors << {message: "Num_tickets_sold must be greater than 0.", variable: "num_tickets_sold"}
      end
    else
      @errors << {message: "Num_tickets_sold must be a number.", variable: "num_tickets_sold"}
    end
    # returns whether @errors is empty
    @errors.empty?
  end
  
  
  # overwrites saved_already in this case because the primary key is not created by the database
  #
  # returns Boolean
  def saved_already?
    ! LocationTime.create_from_database(location_id, timeslot_id).location_id.to_s.empty?
  end
  
  # creates a new record in the table for this object
  # overwrites save_record because it has a composite key
  #
  #
  # returns Integer or false
  def save_record
    if !saved_already?
      if valid?
        CONNECTION.execute("INSERT INTO #{table} (#{string_field_names}, timeslot_id, location_id) VALUES (#{stringify_self}, #{timeslot_id}, #{location_id});")
      else
        false
      end
    else
      update_record
    end
  end
  
  # overwrites Modules update_record method because this object has a composite key
  #
  # returns false if not updated successfully
  def update_field(change_field, change_value)
    if change_value.is_a? String
      change_value = add_quotes_to_string(change_value)
    end
    if valid?
      CONNECTION.execute("UPDATE #{table} SET #{change_field} = #{change_value} WHERE location_id = #{@location_id} AND timeslot_id = #{@timeslot_id};")
    else
      false
    end
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_time
    LocationTime.where_match("timeslot_id", @timeslot_id, "==")
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_movie
    LocationTime.where_match("movie_id", @movie_id, "==")
  end
  
  # overwrites database_connector method because this has a composite id
  # returns an Array of field names for this object
  #
  # returns an Array
  def database_field_names
    attributes = instance_variables.collect{|a| a.to_s.gsub(/@/,'')}
    attributes.delete("location_id")
    attributes.delete("timeslot_id")
    attributes.delete("errors")
    attributes
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
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN locations location ON location.id = locationtime.location_id WHERE location.num_seats <= locationtime.num_tickets_sold;"))
   else
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN locations location ON location.id = locationtime.location_id WHERE location.num_seats > locationtime.num_tickets_sold;"))
   end
  end
  
  # overwrites DatabaseConnector Module method because this Class has a composite key
  #
  # location_id     - Integer of the location_id part of the composite key
  # timeslot_id     - Integer of the timeslot_id part of the composite key
  #
  # returns Array if deleted, false if not successful
  def self.delete_record(location_id, timeslot_id)
    if ok_to_delete?(location_id)
      CONNECTION.execute("DELETE FROM #{self.to_s.pluralize} WHERE location_id == #{location_id} AND timeslot_id == #{timeslot_id}")
    else
      false
    end
  end
  
  # overwrites DatabaseConnector Module method because this Class has a composite key
  #
  # location_id     - Integer of the location_id part of the composite key
  # timeslot_id     - Integer of the timeslot_id part of the composite key
  #
  # returns object with this location_id/timeslot_id
  def self.create_from_database(location_id, timeslot_id)
    rec = CONNECTION.execute("SELECT * FROM #{self.to_s.pluralize} WHERE location_id = #{location_id} AND timeslot_id = #{timeslot_id};").first
    if rec.nil?
      self.new()
    else
      seslf.new(rec)
    end
  end
  
end