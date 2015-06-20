require "minitest/autorun"
require_relative "location.rb"
require_relative "location_time.rb"


CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")
class LocationTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    loc = Location.new("id" => 1, "num_seats" => 300, "num_staff" => 2, "name" => "Purple", "num_time_slots" => 2)
    assert_equal(300, loc.num_seats)
    assert_equal(2, loc.num_staff)
    assert_equal("Purple", loc.name)
    assert_equal(2, loc.num_time_slots)
    
    loc2 = Location.new( num_seats: 300, num_staff: 2, name: "Purple", num_time_slots: 2)
    assert_equal(300, loc2.num_seats)
    assert_equal(2, loc2.num_staff)
    assert_equal("Purple", loc2.name)
    assert_equal(2, loc2.num_time_slots)
    
  end
  
  
  def test_crud
    l = Location.new( num_seats: 300, num_staff: 2, name: "Purple", num_time_slots: 2)
    assert_equal(Fixnum, l.save_record.class)
    l.name = "Pur"
    assert_equal(Array, l.update_record.class)
    assert_equal(Array, Location.delete_record(l.id).class)
    assert_equal(Location, Location.all.first.class)
  end
  
  
  def test_has_avalable_time_slot
    l = Location.new( num_seats: 300, num_staff: 2, name: "Purple", num_time_slots: 2)
    assert_equal(true, l.has_available_time_slot?)
  end
  
  # Tests that this returns an integer
  def test_max_num_time_slots
    assert_equal(Location.max_num_time_slots.class, Fixnum)
  end
  
  # Tests that this returns an Array
  def test_where_available
    assert_equal(Location.where_available(true).class, Array)
    assert_equal(Location.where_available(false).class, Array)
  end
  
  def test_location_times
    l = Location.create_from_database(1)
    assert_equal(l.location_times[1].class, LocationTime)
  end
  
  def test_valid
    # Can't be nil
    l = Location.new(num_seats: nil, num_staff: nil, name: nil, num_time_slots: nil)
    l.valid?
    assert_equal(4, l.errors.length)
    
    # can't be empty strings
    l = Location.new( num_seats: "", num_staff: "", name: "", num_time_slots: "")    
    l.valid?
    assert_equal(4, l.errors.length)
    
    # can't be whatever is created when no args are passed
    l = Location.new()
    l.valid?
    assert_equal(4, l.errors.length)
    
    
    # nums must be numbers
    l = Location.new( num_seats: "s", num_staff: "s", name: "s", num_time_slots: "s")    
    l.valid?
    assert_equal(3, l.errors.length)
    
    # num_staff and num_seats must be greater than 0
    l = Location.new( num_seats: 0, num_staff: 0, name: 0, num_time_slots: 0)    
    l.valid?
    assert_equal(2, l.errors.length)
    
    
    # num_time_slots can't be more than the maximum number of time slots allowed
    l = Location.new( num_seats: 1, num_staff: 1, name: "s", num_time_slots: Location.max_num_time_slots)    
    l.valid?
    assert_equal(0, l.errors.length)
    l.num_time_slots = Location.max_num_time_slots + 1
    l.valid?
    assert_equal(1, l.errors.length)
    
  end
  
end