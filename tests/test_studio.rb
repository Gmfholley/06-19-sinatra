require "minitest/autorun"
require "./lib/theatre_manager.rb"
# require_relative  "movie.rb"
# require_relative "studio.rb"


# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class StudioTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    studio = Studio.new("id" => 1, "name" =>"Purple")
    assert_equal("Purple", studio.name)
    
    studio2 = Studio.new(id: 1, name: "Purple")
    assert_equal("Purple", studio2.name)
    
  end
  
  def test_crud
    s = Studio.new( name: "test")
    assert_equal(Fixnum, s.save_record.class)
    s.name = "Pur"
    assert_equal(Array, s.update_record.class)
    
    assert_equal(true, Studio.ok_to_delete?(s.id))
    
    assert_equal(Array, Studio.delete_record(s.id).class)
    assert_equal(Studio, Studio.all.first.class)
  end
  
  # tested ok to to delete previously above
  def test_ok_to_delete
    assert_equal(false, Studio.ok_to_delete?(11))
  end
  
  def test_valid
    # Can't be nil
    s = Studio.new(name: nil)
    s.valid?
    assert_equal(1, s.errors.length)
    
    # can't be empty strings
    s = Studio.new(name: "")    
    s.valid?
    assert_equal(1, s.errors.length)
    
    # can't be whatever is created when no args are passed
    s = Studio.new()
    s.valid?
    assert_equal(1, s.errors.length)
  end
  
end