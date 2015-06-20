require "minitest/autorun"
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require "./lib/theatre_manager.rb"
# require_relative "movie.rb"
# require_relative "rating.rb"
# require_relative "location_time.rb"
# require_relative "timeslot.rb"
# require_relative "studio.rb"
# require_relative "location.rb"


# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class MovieTest < Minitest::Test


  def test_initialize
    movie = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1, 
    "studio_id" => 1, "length" => 1)
    
    assert_equal("Wendy", movie.name)
    assert_equal("In a world!", movie.description)
    assert_equal("G", movie.rating)
    assert_equal("Paramount", movie.studio)
    assert_equal(1, movie.length)
    
    movie = Movie.new(name: "Wendy", description: "In a world!", rating_id: 1,"studio_id": 1, "length": 1)
    
    assert_equal("Wendy", movie.name)
    assert_equal("In a world!", movie.description)
    assert_equal("G", movie.rating)
    assert_equal("Paramount", movie.studio)
    assert_equal(1, movie.length)
    #
    # @id = args["id"] || ""
    # @name = args[:name] || args["name"]
    # @description = args[:description] || args["description"]
    # @rating_id = args[:rating_id] || args["rating_id"]
    # @studio_id = args[:studio_id] || args["studio_id"]
    # @length = args[:length] || args["length"]
  end
  
  
  def test_to_s
    movie = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1, 
    "studio_id" => 1, "length" => 1)
    movie_s = "id:\t1\t\tname:\tWendy\t\trating:\tG\t\tstudio:\tParamount\t\tlength:\t1"
    # "id:\t#{@id}]\t\tname:\t#{name}\t\trating:\t#{rating}\t\tstudio:\t#{studio}\t\tlength:\t#{length}"
    
    assert_equal(movie_s, movie.to_s)
  end
  
  
  def test_crud
    m = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1, 
    "studio_id" => 1, "length" => 1)
    assert_equal(Fixnum, m.save_record.class)
    m.name = "Pur"
    assert_equal(Array, m.update_record.class)
    assert_equal(true, Movie.ok_to_delete?(m.id))
    
    assert_equal(Array, Movie.delete_record(m.id).class)
    assert_equal(Movie, Movie.all.first.class)
  end
  
  # the first movie should be booked
  # but maybe it won't after a while
  def test_ok_to_delete
    m = Movie.new("name" => "Wendy", "description" => "In a world!", "rating_id" => 1, 
    "studio_id" => 1, "length" => 1)
    m.save_record
    l = LocationTime.new(location_id: 3, timeslot_id: 5, movie_id: m.id)
    l.save_record
    assert_equal(false, Movie.ok_to_delete?(m.id))
    LocationTime.delete_record(l.location_id, l.timeslot_id)
    assert_equal(true, Movie.ok_to_delete?(m.id))
    Movie.delete_record(m.id)
  end
 
  def test_location_times
    m = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1, 
    "studio_id" => 1, "length" => 1)
    assert_equal(Array, m.location_times.class)
    
    m = Movie.create_from_database(1)
    assert_equal(LocationTime, m.location_times.first.class)
  end

 
  def test_valid
    # Can't be nil
    m = Movie.new(name: nil, description: nil, studio_id: nil, rating_id: nil, length: nil)
    m.valid?
    assert_equal(5, m.errors.length)

    # can't be empty strings
    m = Movie.new(name: "", description: "", studio_id: "", rating_id: "", length: "")
    m.valid?
    assert_equal(5, m.errors.length)

    # can't be whatever is created when no args are passed
    m = Movie.new()
    m.valid?
    assert_equal(5, m.errors.length)


    # rating & studio id must belong to the table; length must be a number
    m = Movie.new(name: "s", description: "s", studio_id: "s", rating_id: "s", length: "s")
    m.valid?
    assert_equal(3, m.errors.length)

    # length must be 0 or greater, and studio & rating must belong to the table
    m = Movie.new(name: 0, description: 0, studio_id: 0, rating_id: 0, length: 0)
    m.valid?
    assert_equal(2, m.errors.length)


    # num_time_slots can't be more than the maximum number of time slots allowed
    m = Movie.new(name: 1, description: 1, studio_id: Studio.all.last.id + 1, rating_id: Rating.all.last.id + 1, length: 0)
    m.valid?
    assert_equal(2, m.errors.length)
    m.studio_id = Studio.all.last.id
    m.rating_id = Rating.all.last.id
    m.valid?
    assert_equal(0, m.errors.length)

  end

  
end