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
  erb :menu
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
  binding.pry
  if @m.save_record
    "Successfully saved!"
  else
    @foreign_key_choices = []
    all_foreign_keys = @m.foreign_keys
    all_foreign_keys.each do |foreign_key|
      @foreign_key_choices << foreign_key.all_from_class
    end   
    erb :create
  end
  
end


get "/delete/:something" do

  @class_name = slash_to_class_names[params["something"]]
  m = TheatreManager.new()
  
  @menu = m.user_choice_of_object_in_class(@class_name)
  erb :menu
  
end


get "/delete/:something/:x" do
  
  @class_name = slash_to_class_names[params["something"]]
  if @class_name.delete_record(params["x"].to_i)
    "Successfully deleted."
  else
    "This object was not found or was in another table.  Not deleted."
  end
  
  #erb :menu
end


get "/update/:something" do
  @class_name = slash_to_class_names[params["something"]]
  m = TheatreManager.new()
  
  @menu = m.user_choice_of_object_in_class(@class_name)
  
  erb :menu
end

get "/update/:something/:x" do
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

get "/:other" do
  erb :not_appearing
end


def slash_to_class_names
  {"theatre" => Location, "location_time" => LocationTime, "movie" => Movie}
end