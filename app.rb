require 'sinatra'
require 'pry'
require 'sinatra/reloader'
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require_relative '/Users/gwendolyn/code/06-12-Database/lib/theatre_manager.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

get "/home" do
  @m = TheatreManager.new
  @menu = @m.home
  erb :menu
end

get "/movie" do
  m = TheatreManager.new
  @menu = m.movie
  @clas = "movie"
  erb :menu
end

get "/theatre" do
  m = TheatreManager.new
  @menu = m.theatre
  @class = "location"
  erb :menu
end

get "/location_time" do
  m = TheatreManager.new
  @menu = m.location_time
  @class = "location_time"
  erb :menu
end

get "/analyze" do
  m = TheatreManager.new
  @menu = m.analyze
  @class = ""
  erb :menu
end

get "/create/movie" do
  m = TheatreManager.new
  @menu = m.analyze
  @class = ""
  erb :menu
end

get "/:other" do
  erb :not_appearing
end