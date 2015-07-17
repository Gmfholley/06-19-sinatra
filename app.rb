require 'active_record'
require 'sinatra'
require 'sinatra/reloader'
require 'active_support.rb'
require 'active_support/core_ext/object/blank.rb'
require 'sqlite3'
require 'pry'

require_relative "database_setup.rb"

#models
require_relative 'models/studio.rb'
require_relative 'models/rating.rb'
require_relative 'models/time_slot.rb'
require_relative 'models/movie.rb'
require_relative 'models/location.rb'
require_relative 'models/location_time.rb'


#helper classes
require_relative 'controllers/menu.rb'
require_relative 'controllers/menu_item.rb'
require_relative 'controllers/method_to_call.rb'

#controllers
require_relative 'controllers/defined_menu_helper.rb'
require_relative 'controllers/main_helper.rb'
require_relative 'controllers/main_controller.rb'

helpers MenuHelper, MenuObjectHelper

#
# get "/home" do
#   "yes"
# end