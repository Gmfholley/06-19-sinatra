require "minitest/autorun"
require "./lib/theatre_manager.rb"
# require_relative 'movie.rb'
# require_relative "rating.rb"


# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class RatingTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    rating = Rating.new("id" => 1, "rating" => "Purple")
    assert_equal("Purple", rating.rating)
    
    rating2 = Rating.new(rating: "Purple")
    assert_equal("Purple", rating2.rating)
    
  end
  
  def test_crud
    r = Rating.new( rating: "test")
    assert_equal(Fixnum, r.save_record.class)
    r.rating = "Pur"
    assert_equal(Array, r.update_record.class)
    assert_equal(true, Rating.ok_to_delete?(r.id))
    assert_equal(Array, Rating.delete_record(r.id).class)
    assert_equal(Rating, Rating.all.first.class)
  end
  
  # tests true above in crud
  def test_ok_to_delete
    assert_equal(false, Rating.ok_to_delete?(3))
  end
  
  def test_valid
    # Can't be nil
    r = Rating.new(rating: nil)
    r.valid?
    assert_equal(1, r.errors.length)
    
    # can't be empty strings
    r = Rating.new(rating: "")    
    r.valid?
    assert_equal(1, r.errors.length)
    
    # can't be whatever is created when no args are passed
    r = Rating.new()
    r.valid?
    assert_equal(1, r.errors.length)
  end
  
end