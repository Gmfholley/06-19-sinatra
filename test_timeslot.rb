require "minitest/autorun"
require_relative "timeslot.rb"

class TimeTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    timeslot = Time.new("id" => 1, "time" => 12)
    assert_equal(12, timeslot.time_slot)
    
    timeslot2 = Time.new(id: 1, time: 12)
    assert_equal(12, timeslot2.time_slot)
    
  end
  
end