require 'active_record'
require 'sinatra'
require 'pry'
require 'sinatra/reloader'
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'


require_relative "database_setup.rb"

# models
require_relative 'models/studio.rb'
require_relative 'models/rating.rb'
require_relative 'models/time_slot.rb'
require_relative 'models/movie.rb'
require_relative 'models/location.rb'
require_relative 'models/location_time.rb'

#controllers
require_relative 'controllers/defined_menu_helpers'
require_relative 'controllers/main_controller.rb'

helpers MenuHelper