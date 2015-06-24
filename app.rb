require 'sinatra'
require 'pry'
require 'sinatra/reloader'
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require_relative '/Users/gwendolyn/code/06-19-Database/lib/theatre_manager.rb'

# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

get "/home" do
  m = TheatreManager.new
  @menu = m.home
  erb :menu
end

get "/movie" do
  m = TheatreManager.new
  @menu = m.movie
  @class_name = Movie
  erb :menu
end

get "/theatre" do
  m = TheatreManager.new
  @menu = m.theatre
  @class_name = Location
  erb :menu
end

get "/location_time" do
  m = TheatreManager.new
  @menu = m.location_time
  @class_name = LocationTime
  erb :menu_without_links
end

get "/analyze" do
  m = TheatreManager.new
  @menu = m.analyze
  @next_slash = "/analyze"
  erb :menu
end

get "/create/:something/:x" do
  #Get class name
  @class_name = slash_to_class_names[params["something"]]
  
  # create an object so you can get its instance variables
  @m = @class_name.create_from_database(params["x"].to_i)
  # get foreign key names in this object and all possible values of the foreign key
  @foreign_key_choices = []
  all_foreign_keys = @m.foreign_keys
  all_foreign_keys.each do |foreign_key|
    @foreign_key_choices << foreign_key.all_from_class
  end
  
  erb :create
end

get "/submit/:something" do
  @class_name = slash_to_class_names[params["something"]]
  
  @m = @class_name.new(params)
  
  if @m.save_record
    @message = "Successfully saved!"
    erb :message
  else
    @foreign_key_choices = []
    all_foreign_keys = @m.foreign_keys
    all_foreign_keys.each do |foreign_key|
      @foreign_key_choices << foreign_key.all_from_class
    end   
    erb :create
  end
  
end


get "/show/:something" do

  @class_name = slash_to_class_names[params["something"]]
  m = TheatreManager.new()
  
  @menu = m.user_choice_of_object_in_class(@class_name)
  @menu.title = "Here are all the #{params["something"].pluralize}."
  erb :menu_without_links
  
end

get "/delete/:something" do

  @class_name = slash_to_class_names[params["something"]]
  m = TheatreManager.new()
  
  @menu = m.user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{params["something"]} do you want to delete?"
  erb :menu
  
end


get "/delete/:something/:x" do
  
  @class_name = slash_to_class_names[params["something"]]
  if @class_name.delete_record(params["x"].to_i)
    @message = "Successfully deleted."
    erb :message
  else
    @message = "This #{params["something"]} was not found or was in another table.  Not deleted."
    erb :message
  end
  
  #erb :menu
end

get "/update/:something" do
  @class_name = slash_to_class_names[params["something"]]
  m = TheatreManager.new()  
  @menu = m.user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want to update?"
  erb :menu
end

get "/update/:something/:x" do
  #Get class name
  @class_name = slash_to_class_names[params["something"]]
  
  # create the object
  @m = @class_name.create_from_database(params["x"].to_i)
  # get foreign key names in this object and all possible values of the foreign key
  @foreign_key_choices = []
  all_foreign_keys = @m.foreign_keys
  all_foreign_keys.each do |foreign_key|
    @foreign_key_choices << foreign_key.all_from_class
  end
  
  erb :create
end

get "/get_time_location/:something" do
 
  @class_name = slash_to_class_names[params["something"]]
  #params["something"] = "get_time_location_for_movie"
  m = TheatreManager.new()  
  @menu = m.user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want time/location information for?"
  erb :menu
end

get "/get_time_location/:something/:x" do
  
  @class_name = slash_to_class_names[params["something"]]
  @m = @class_name.create_from_database(params["x"].to_i)
  @menu = Menu.new("The times and locations for #{@m.name} are:")
  
  @m.location_times.each do |lt|
    @menu.add_menu_item(user_message: lt.to_s)
  end
  
  erb :menu_without_links
end


get "/get_available_locations" do
  m = TheatreManager.new
  @menu = m.available
  params["something"] = "get_available_locations"
  erb :menu
end

get "/get_available_locations/:something" do  
  if params["something"] == "available"
    @m = Location.where_available(true)
  else
    @m = Location.where_available(false)
  end
  
  @menu = Menu.new("The #{params["something"].humanize.downcase} times and locations are:")
  @m.each do |lt|
    @menu.add_menu_item(user_message: lt.to_s)
  end
  
  erb :menu_without_links
end

get "/get_sold_time_locations" do
  
  m = TheatreManager.new
  @menu = m.sold_out
  params["something"] = "get_sold_time_locations"
  erb :menu
end

get "/get_sold_time_locations/:x" do
  if params["x"] == "sold_out"
    @m = LocationTime.where_sold_out(true)
  else
    @m = LocationTime.where_sold_out(false)
  end
  
  @menu = Menu.new("The #{params["x"]} times and locations are:")
  @m.each do |lt|
    @menu.add_menu_item(user_message: lt.to_s)
  end
  
  erb :menu_without_links
end

get "/get_movies_like_this" do
  
  m = TheatreManager.new
  @menu = m.movie_type_lookup_menu
  params["something"] = "get_movies_like_this"
  erb :menu
end

get "/get_movies_like_this/:something" do
  @class_name = slash_to_class_names[params["something"]]
  m = TheatreManager.new()  
  @menu = m.user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want to look up?"
  erb :menu
end

get "/get_movies_like_this/:something/:x" do
  all_movies = Movie.where_match("#{params["something"]}_id", params["x"].to_i, "==")
  
  @menu = Menu.new("These are the movies that match this #{params["something"]}.")
  all_movies.each do |movie|
    @menu.add_menu_item(user_message: movie.to_s)
  end
  
  erb :menu_without_links

end

get "/get_num_staff_needed" do
  @class_name = TimeSlot
  m = TheatreManager.new()  
  @menu = m.user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want to look up the number of staff for?"
  params["something"] = "get_num_staff_needed"
  erb :menu

end

get "/get_num_staff_needed/:x" do
  binding.pry
  params["something"] = "analyze"
  m = TimeSlot.create_from_database(params["x"].to_i)
  binding.pry
  @message = "You will need #{m.num_staff_needed} staff members for the #{m.name} time slot."
  erb :message

end


get "/:other" do
  erb :not_appearing
end

###################
def slash_to_class_names
  {"theatre" => Location, "location_time" => LocationTime, "movie" => Movie, "time" => TimeSlot, "studio" => Studio, "rating" => Rating}
end