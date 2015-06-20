require "minitest/autorun"
require_relative "studio.rb"

class StudioTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    studio = Studio.new("id" => 1, "name" =>"Purple")
    assert_equal("Purple", studio.name)
    
    studio2 = Studio.new(id: 1, name: "Purple")
    assert_equal("Purple", studio2.name)
    
  end
  
end