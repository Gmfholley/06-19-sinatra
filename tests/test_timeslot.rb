require "minitest/autorun"
require "./lib/theatre_manager.rb"
# require_relative "location_time.rb"
# require_relative "timeslot.rb"


#
# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class TimeSlotTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    timeslot = TimeSlot.new("id" => 1, "time_slot" => 12)
    assert_equal(12, timeslot.time_slot)
    
    timeslot2 = TimeSlot.new(id: 1, time_slot: 12)
    assert_equal(12, timeslot2.time_slot)
    
  end

  def test_crud
    t = TimeSlot.new( time_slot: "test")
    assert_equal(Fixnum, t.save_record.class)
    t.time_slot = "pur"
    assert_equal(Array, t.update_record.class)
    
    assert_equal(true, TimeSlot.ok_to_delete?(t.id))
    
    assert_equal(Array, TimeSlot.delete_record(t.id).class)
    assert_equal(TimeSlot, TimeSlot.all.first.class)
  end
  
  # tested ok to to delete previously above
  def test_ok_to_delete
    assert_equal(false, TimeSlot.ok_to_delete?(1))
  end
  
  def test_valid
    # Can't be nil
    t = TimeSlot.new(time_slot: nil)
    t.valid?
    assert_equal(1, t.errors.length)
    
    # can't be empty strings
    t = TimeSlot.new(time_slot: "")    
    t.valid?
    assert_equal(1, t.errors.length)
    
    # can't be whatever is created when no args are passed
    t = TimeSlot.new()
    t.valid?
    assert_equal(1, t.errors.length)
  end
  
  def test_num_staff_needed
  end
  
end