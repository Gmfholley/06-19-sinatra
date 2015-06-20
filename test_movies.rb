require "minitest/autorun"
require_relative "movie.rb"
require_relative "rating.rb"
require_relative "studio.rb"

class MovieTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  
  
  def test_initialize
    movie = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1, "studio_id" => 1, "length" => 1)
    
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
    
    
    movie = Movie.create_from_database(1)
    
    assert_equal("Age of Ultron", movie.name)
    assert_equal("In a word where superheroes come together to face evil...", movie.description)
    assert_equal("PG-13", movie.rating)
    assert_equal("Marvel Studios", movie.studio)
    assert_equal(160, movie.length)
    #
    # @id = args["id"] || ""
    # @name = args[:name] || args["name"]
    # @description = args[:description] || args["description"]
    # @rating_id = args[:rating_id] || args["rating_id"]
    # @studio_id = args[:studio_id] || args["studio_id"]
    # @length = args[:length] || args["length"]
  end
  
  
  def test_to_s
    movie = Movie.new("id" => 1, "name" => "Wendy", "description" => "In a world!", "rating_id" => 1, "studio_id" => 1, "length" => 1)
    movie_s = "id:\t1\t\tname:\tWendy\t\trating:\tG\t\tstudio:\tParamount\t\tlength:\t1"
    # "id:\t#{@id}]\t\tname:\t#{name}\t\trating:\t#{rating}\t\tstudio:\t#{studio}\t\tlength:\t#{length}"
    
    assert_equal(movie_s, movie.to_s)
  end
  
end