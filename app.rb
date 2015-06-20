require 'sinatra'
require 'sinatra/reloader'
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require_relative '/Users/gwendolyn/code/06-12-Database/lib/theatre_manager.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

get "/home" do
  (1...1000).each do |x|
    x.to_s
  end

end