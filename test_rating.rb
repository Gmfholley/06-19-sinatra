require "minitest/autorun"
require_relative "rating.rb"

class RatingTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    rating = Rating.new("id" => 1, "rating" => "Purple")
    assert_equal("Purple", rating.rating)
    
    rating2 = Rating.new(rating: "Purple")
    assert_equal("Purple", rating2.rating)
    
  end
  
end