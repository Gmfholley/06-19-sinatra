require "minitest/autorun"
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require "./lib/theatre_manager.rb"
# require_relative "movie.rb"
# require_relative "location.rb"
# require_relative "timeslot.rb"
# require_relative "location_time.rb"


# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class LocationTimeTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  
  
  def test_initialize
    loctime = LocationTime.new("location_id" => 1, "timeslot_id" => 2, "movie_id" => 3, "num_tickets_sold" => 
    1)  
    assert_equal(1, loctime.location_id)
    assert_equal(2, loctime.timeslot_id)
    assert_equal(3, loctime.movie_id)
    assert_equal(1, loctime.num_tickets_sold)


    loctime2 = LocationTime.new(location_id: 1, "timeslot_id": 2, "movie_id": 3, "num_tickets_sold": 1)  
    assert_equal(1, loctime2.location_id)
    assert_equal(2, loctime2.timeslot_id)
    assert_equal(3, loctime2.movie_id)
    assert_equal(1, loctime2.num_tickets_sold)
    
    loctime2 = LocationTime.create_from_database(1, 3)  
    assert_equal(1, loctime2.location_id)
    assert_equal(3, loctime2.timeslot_id)
    assert_equal(1, loctime2.movie_id)
    assert_equal(0, loctime2.num_tickets_sold)
    
    # @location_id = args[:location_id] || args["location_id"]
    # @timeslot_id = args[:timeslot_id] || args["timeslot_id"]
    # @movie_id = args[:movie_id] || args["movie_id"]
    # @num_tickets_sold = 0
  end
  
  
  def test_to_s
    loctime2 = LocationTime.new(location_id: 1, "timeslot_id": 2, "movie_id": 3, "num_tickets_sold": 1)  
    loctime_s = "location:\tPurple\t\ttimeslot:\t14:30:00\t\tmovie:\tGuardians of the Galaxy"
     # "location:\t#{location}\t\ttimeslot:\t#{timeslot}\t\tmovie:\t#{movie}"
    assert_equal(loctime_s, loctime2.to_s)
  end
  
  def test_tickets_sold
     loctime2 = LocationTime.create_from_database(1, 3)
       # "location:\t#{location}\t\ttimeslot:\t#{timeslot}\t\tmovie:\t#{movie}"
     assert_equal(300, loctime2.tickets_remaining)
     assert_equal(false, loctime2.sold_out?)
  end
  
  def test_crud
    l = LocationTime.new(location_id: 6, timeslot_id: 2, movie_id: 1, num_tickets_sold: 2)
    assert_equal(Array, l.save_record.class)
    l.num_tickets_sold= 3
    assert_equal(Array, l.update_record.class)
    assert_equal(Array, LocationTime.delete_record(l.location_id, l.timeslot_id).class)
    assert_equal(LocationTime, LocationTime.all.first.class)
  end
  
  
  def test_sold_out
    l = LocationTime.new(location_id: 1, num_tickets_sold: Location.create_from_database(1).num_seats)
    assert_equal(true, l.sold_out?)
    l.num_tickets_sold = l.num_tickets_sold - 1
    assert_equal(false, l.sold_out?)
  end
  
  # # Tests that this returns an integer
  # def test_max_num_time_slots
  #   assert_equal(LocationTime.max_num_time_slots.class, Fixnum)
  # end
  #
  # # Tests that this returns an Array
  # def test_where_available
  #   assert_equal(LocationTime.where_available(true).class, Array)
  #   assert_equal(LocationTime.where_available(false).class, Array)
  # end
  #
  # def test_location_times
  #   l = LocationTime.create_from_database(1)
  #   assert_equal(l.location_times[1].class, LocationTimeTime)
  # end
  
  def test_valid
    # Can't be nil
    # num_tickets_sold defaults to 0
    l = LocationTime.new(location_id: nil, timeslot_id: nil, movie_id: nil, num_tickets_sold: nil)
    l.valid?
    assert_equal(3, l.errors.length)
    
    # can't be empty strings
    l = LocationTime.new( location_id: "", timeslot_id: "", movie_id: "", num_tickets_sold: "")    
    l.valid?
    assert_equal(4, l.errors.length)
    
    # can't be whatever is created when no args are passed
    # num_tickets_sold defaults to 0
    l = LocationTime.new()
    l.valid?
    assert_equal(3, l.errors.length)
    
    
    #  all must be numbers
    l = LocationTime.new(location_id: "s", timeslot_id: "s", movie_id: "s", num_tickets_sold: "s")    
    l.valid?
    assert_equal(4, l.errors.length)
    
    #  all ids must be in their respective tables
    l = LocationTime.new(location_id: 0, timeslot_id: 0, movie_id: 0, num_tickets_sold: 0)    
    l.valid?
    assert_equal(3, l.errors.length)
    
    
    loc = Location.create_from_database(1)
    # num_time_slots can't be more than the maximum number of time slots allowed
    l = LocationTime.new(location_id: 1, timeslot_id: 1, movie_id: 1, num_tickets_sold: 
    loc.num_seats)
    l.valid?
    assert_equal(0, l.errors.length)
    
    l.num_tickets_sold += 1
    l.valid?
    assert_equal(1, l.errors.length)
    
    l = LocationTime.new(location_id: Location.all.last.id + 1, timeslot_id: TimeSlot.all.last.id + 1, 
    movie_id: Movie.all.last.id + 1)
    l.valid?
    assert_equal(3, l.errors.length)
    
  end
  
end