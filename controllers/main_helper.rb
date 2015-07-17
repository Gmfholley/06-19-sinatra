module MenuObjectHelper
  
    # defines and runs Main Menu
    #
    # calls the main menu
    def home
        main = Menu.new("What would you like to work on?")
        main.add_menu_item({key_user_returns: 1, user_message: "Work with movies.", do_if_chosen: "movie"})
        main.add_menu_item({key_user_returns: 2, user_message: "Work with theatres.", do_if_chosen:"theatre"})
        main.add_menu_item({key_user_returns: 3, user_message: "Schedule movie time slots by theatre.", do_if_chosen: "location_time"})
        main.add_menu_item({key_user_returns: 4, user_message: "Run an analysis on my theatres.", do_if_chosen: "analyze"})
        main
    end
  
    # defines and runs the movie menu
    #
    # calls the theatre menu
    def movie
        movie = Menu.new("What would you like to do with movies?")
        movie.add_menu_item({key_user_returns: 1, user_message: "Create a movie.", do_if_chosen: "create/movie"})
        movie.add_menu_item({key_user_returns: 2, user_message: "Update a movie.", do_if_chosen: "update/movie", parameters: [Movie, "movie"]})
        movie.add_menu_item({key_user_returns: 3, user_message: "Show me movies.", do_if_chosen:"show/movie", parameters: [Movie, "movie"]})
        movie.add_menu_item({key_user_returns: 4, user_message: "Delete a movie.", do_if_chosen:"delete/movie", parameters: [Movie, "movie"]})
        movie.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: "home"})
        movie
    end
  
    # defines and runs the theatre menu
    #
    # runs the theatre menu
    def theatre
        theatre = Menu.new("What would you like to do with theatres?")
        theatre.add_menu_item({key_user_returns: 1, user_message: "Create a theatre.", do_if_chosen: "create/theatre"})
        theatre.add_menu_item({key_user_returns: 2, user_message: "Update a theatre.", do_if_chosen: "update/theatre", parameters: [Location, "theatre"]})
        theatre.add_menu_item({key_user_returns: 3, user_message: "Show me theatres.", do_if_chosen: "show/theatre", parameters: [Location, "theatre"]})
        theatre.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre.", do_if_chosen:"delete/theatre", parameters: [Location, "theatre"]})
        theatre.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: "home"})
        theatre
    end
    
    # defines and runs the LocationTime menu
    #
    # runs the LocationTime menu
    def location_time
      loc_time = Menu.new("What would you like to do with movie time/theatre slots?")
      loc_time.add_menu_item({key_user_returns: 1, user_message: "Create a new theatre/time slot.", 
        do_if_chosen: "create/location_time", parameters:[LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 2, user_message: "Update a theatre/time slot.", 
        do_if_chosen: "update/location_time", parameters:[LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 3, user_message: "Show me theatre/time slot.", 
        do_if_chosen: "show/location_time", parameters:[LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre/time slot.", 
        do_if_chosen: "delete/location_time", parameters:[LocationTime, "location_time"]})
      loc_time.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: "home"})
      loc_time       
    end
  
    # defines and runs the analyze menu
    #
    # runs the analyze menu
    def analyze
        analyze = Menu.new("What would you like to see?")
        analyze.add_menu_item({key_user_returns: 1, user_message: "Get all time/theatres for a particular 
          movie.", do_if_chosen: "get_time_location/movie"})
        analyze.add_menu_item({key_user_returns: 2, user_message: "Get all times for a particular theatre.", 
          do_if_chosen: "get_time_location/theatre"})
        analyze.add_menu_item({key_user_returns: 3, user_message: "Get all movies played at this time.", 
          do_if_chosen: "get_time_location/time"})
        analyze.add_menu_item({key_user_returns: 4, user_message: "Get all time/theatres that are sold out or 
          not sold out.", do_if_chosen: "get_sold_time_locations"})
        analyze.add_menu_item({key_user_returns: 5, user_message: "Get all movies from a particular studio or 
          rating.", do_if_chosen: "get_movies_like_this"})
        analyze.add_menu_item({key_user_returns: 6, user_message: "Get all theatres that are booked or not 
          fully booked.", do_if_chosen: "get_available_locations"})
        analyze.add_menu_item({key_user_returns: 7, user_message: "Get number of staff needed for a time 
          slot.", do_if_chosen: "get_num_staff_needed"})
        analyze.add_menu_item({key_user_returns: 8, user_message: "Return to main menu.", do_if_chosen: "home"})
        analyze
    end
  
    def available
      create_menu  = Menu.new("Do you want to get all available or not available?")
      create_menu.add_menu_item({key_user_returns: 1, user_message: "Available", do_if_chosen: "available"})
      create_menu.add_menu_item({key_user_returns: 2, user_message: "Not available", do_if_chosen: "not_available"})
      create_menu
    end
  
  
    def sold_out
      create_menu  = Menu.new("Do you want to get all those that are sold out or not sold out?")
      create_menu.add_menu_item({key_user_returns: 1, user_message: "Sold out", do_if_chosen: "sold_out"})
      create_menu.add_menu_item({key_user_returns: 2, user_message: "Not sold out", do_if_chosen: "not_sold_out"})
      create_menu
    end
  
    def movie_type_lookup_menu
      create_menu = Menu.new("What do you want to look up?")
      create_menu.add_menu_item({key_user_returns: 1, user_message: "Studios", do_if_chosen: "studio"})
      create_menu.add_menu_item({key_user_returns: 2, user_message: "Ratings", do_if_chosen: "rating"})
      create_menu
    end
  
    # accepts a Class, creates a menu of all instances of that object from the database, and returns an instance of the object from the database that the user selects
    # requires the DatabaseConnector module to be used
    #
    # class_object - Class object (like Movie or Student)
    #
    # returns Menu
    def user_choice_of_object_in_class(class_object)
      create_menu = Menu.new("Which #{class_object.name} do you want to look up?")
      all = class_object.all
      all.each_with_index do |object, x|
        object_to_s = object.attributes.map{|k,v| "#{k}: #{v}"}.join(', ')
        create_menu.add_menu_item({key_user_returns: x + 1, user_message: object_to_s, do_if_chosen: "#{object.id}"})
      end
      create_menu
    end
    # Creates a menu and returns the field name that the user wants to change
    # requires the DatabaseConnector module to be used on the object
    #
    # returns Menu
    def user_choice_of_field(object)
      fields = object.database_field_names
      create_menu = Menu.new("Which field do you want to update?")
      fields.each_with_index do |field, x|
        create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, do_if_chosen: "#{object.class}/#{object.id}/#{field}"})
      end
      create_menu
    end
 
 
    def class_to_slash_names
      {Location => "theatre", LocationTime => "location_time", Movie => "movie", Rating => "rating", Studio => "studio"}
    end

  
end