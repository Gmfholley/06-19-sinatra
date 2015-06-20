require "minitest/autorun"
require_relative "location_time.rb"
require_relative "movie.rb"
require_relative "location.rb"
require_relative "timeslot.rb"

class LocationTimeTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  
  
  def test_initialize
    loctime = LocationTime.new("location_id" => 1, "timeslot_id" => 2, "movie_id" => 3, "num_tickets_sold" => 1)  
    assert_equal(1, loctime.location_id)
    assert_equal(2, loctime.timeslot_id)
    assert_equal(3, loctime.movie_id)
    assert_equal(1, loctime.num_tickets_sold)

    # When num tickets sold is a symbol, do not let it set the number of tickets sold - that is done through normal initialization, not through updating from a hash
    loctime2 = LocationTime.new(location_id: 1, "timeslot_id": 2, "movie_id": 3, "num_tickets_sold": 1)  
    assert_equal(1, loctime2.location_id)
    assert_equal(2, loctime2.timeslot_id)
    assert_equal(3, loctime2.movie_id)
    assert_equal(0, loctime2.num_tickets_sold)
    
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
  
end