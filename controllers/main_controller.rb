get "/home" do
  @menu = home
  erb :menu
end

get "/movie" do

  @menu = movie
  @class_name = Movie
  erb :menu
end

get "/theatre" do
  
  @menu = theatre
  @class_name = Location
  erb :menu
end

get "/location_time" do
  
  @menu = location_time
  @class_name = LocationTime
  erb :menu
end

get "/analyze" do
  
  @menu = analyze
  @next_slash = "/analyze"
  erb :menu
end

get "/create/:something/:x" do
  #Get class name
  @class_name = slash_to_class_names[params["something"]]
  
  # create an object so you can get its instance variables
  @obj = @class_name.find(params["x"])
  # get foreign key names in this object and all possible values of the foreign key
  # @foreign_key_choices = []
  # all_foreign_keys = @obj.foreign_keys
  # all_foreign_keys.each do |foreign_key|
  #   @foreign_key_choices << foreign_key.all_from_class
  # end
  
  erb :create
end

get "/create/:something" do
  #Get class name
  @class_name = slash_to_class_names[params["something"]]
  
  # create an object so you can get its instance variables
  @obj = @class_name.new()
  # get foreign key names in this object and all possible values of the foreign key
  # @foreign_key_choices = []
  # all_foreign_keys = @obj.foreign_keys
  # all_foreign_keys.each do |foreign_key|
  #   @foreign_key_choices << foreign_key.all_from_class
  # end
  
  erb :create
end

post "/submit/:something" do
  @class_name = slash_to_class_names[params["something"]]
  if params["my_object"]["id"] == ""
    @obj = @class_name.new(params["my_object"])
  
    if @obj.save
      @message = "Successfully saved!"
      erb :message
    else
      # @foreign_key_choices = []
      # all_foreign_keys = @obj.foreign_keys
      # all_foreign_keys.each do |foreign_key|
      #   @foreign_key_choices << foreign_key.all_from_class
      # end 
      erb :create
    end
  else
    @obj = @class_name.find(params["id"].to_i)
    @obj.update(params)
    if @obj.save
      @message = "Successfully saved!"
      erb :message
    else
      # @foreign_key_choices = []
      # all_foreign_keys = @obj.foreign_keys
      # all_foreign_keys.each do |foreign_key|
      #   @foreign_key_choices << foreign_key.all_from_class
      # end
      erb :create
    end
  end  
end


get "/show/:something" do

  @class_name = slash_to_class_names[params["something"]]
  ()
  
  @menu = user_choice_of_object_in_class(@class_name)
  @menu.title = "Here are all the #{params["something"].pluralize}."
  erb :menu_without_links
  
end

get "/delete/:something" do

  @class_name = slash_to_class_names[params["something"]]
  ()
  
  @menu = user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{params["something"]} do you want to delete?"
  erb :menu
  
end


get "/delete/:something/:x" do
  
  @class_name = slash_to_class_names[params["something"]]
  if @class_name.delete(params["x"].to_i)
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
  @menu = user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want to update?"
  erb :menu
end

get "/update/:something/:x" do
  #Get class name
  @class_name = slash_to_class_names[params["something"]]
  # create the object
  @obj = @class_name.find(params["x"].to_i)
  erb :create
end

get "/get_time_location/:something" do
 
  @class_name = slash_to_class_names[params["something"]]
  #params["something"] = "get_time_location_for_movie"
  ()  
  @menu = user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want time/location information for?"
  erb :menu
end

get "/get_time_location/:something/:x" do
  
  @class_name = slash_to_class_names[params["something"]]
  @obj = @class_name.find(params["x"].to_i)
  @menu = Menu.new("The times and locations for #{@obj.name} are:")
  
  @obj.location_times.each do |lt|
    @menu.add_menu_item(user_message: lt.to_s)
  end
  
  erb :menu_without_links
end


get "/get_available_locations" do
  
  @menu = available
  params["something"] = "get_available_locations"
  erb :menu
end

get "/get_available_locations/:something" do  
  if params["something"] == "available"
    @obj = Location.where_available(true)
  else
    @obj = Location.where_available(false)
  end
  
  @menu = Menu.new("The #{params["something"].humanize.downcase} times and locations are:")
  @obj.each do |lt|
    @menu.add_menu_item(user_message: lt.to_s)
  end
  
  erb :menu_without_links
end

get "/get_sold_time_locations" do
  
  
  @menu = sold_out
  params["something"] = "get_sold_time_locations"
  erb :menu
end

get "/get_sold_time_locations/:x" do
  if params["x"] == "sold_out"
    @obj = LocationTime.where_sold_out(true)
  else
    @obj = LocationTime.where_sold_out(false)
  end
  
  @menu = Menu.new("The #{params["x"]} times and locations are:")
  @obj.each do |lt|
    @menu.add_menu_item(user_message: lt.to_s)
  end
  
  erb :menu_without_links
end

get "/get_movies_like_this" do
  
  
  @menu = movie_type_lookup_menu
  params["something"] = "get_movies_like_this"
  erb :menu
end

get "/get_movies_like_this/:something" do
  @class_name = slash_to_class_names[params["something"]]
  ()  
  @menu = user_choice_of_object_in_class(@class_name)
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
  ()  
  @menu = user_choice_of_object_in_class(@class_name)
  @menu.title = "Which #{@class_name} do you want to look up the number of staff for?"
  params["something"] = "get_num_staff_needed"
  erb :menu

end

get "/get_num_staff_needed/:x" do
  params["something"] = "analyze"
  m = TimeSlot.find(params["x"].to_i)
  @message = "You will need #{m.num_staff_needed} staff members for the #{m.name} time slot."
  erb :message

end


get "/:other" do
  erb :not_appearing
end

##################