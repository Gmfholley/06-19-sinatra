require_relative 'database_connector.rb'
require_relative 'menu.rb'
require_relative 'menu_item.rb'


# Add this Driver module to your Driver class for a particular project and get awesome menu functionality

module Driver
  
  #################################### Methods that work with Menu and MenuItem classes
 
  # runs Menu object and calls next method
  #
  # Menu - Menu object
  #
  # calls method based on what the user chooses
  def run_menu_and_call_next(menu)
    user_wants = run_menu(menu)
    params = user_wants.slice(1..-1) if user_wants.length > 1
    call_method(user_wants.slice(0), params)
  end
  
  # displays menu and gets user response until user quits or selects a menu item
  #
  # returns menu_items's command of what to run
  def run_menu(menu)
    display_menu(menu)
    user_choice = get_user_input(menu.user_pick_one_prompt)
    while !menu.user_input_valid?(user_choice)
      user_choice = get_user_input(menu.user_wrong_choice_prompt)
    end
    if menu.user_wants_to_quit?(user_choice)
      exit 0
    else
      menu.find_menu_item_chosen(user_choice).do_if_chosen
    end
  end
  
  # displays the menu
  #
  # returns menu_items
  def display_menu(menu)
    puts menu.title
    menu.menu_items.each_with_index { |item| puts "#{item.key_user_returns}.\t #{item.user_message}" }
  end
  
  # displays message and gets user input
  #
  # message - String
  #
  # returns String
  def get_user_input(message)
    puts message
    gets.chomp
  end
  # runs the method name with optional params on this Class's object
  #
  # method_name         - String name of the method in this object to call
  # params (optional)   - String, Integer, Object, or Class of the parameters for the method
  #
  # calls next method
  def call_method(method_name, params=nil)
      if params.nil?
        self.method(method_name).call
      else
        self.method(method_name).call(params)
      end
  end
  
  ################################
  #             Working with records in a database
  #
  #             These methods require that your objects have included/extended the DatabaseConnector modules
  # 
  #             These methods allow you to pass the Class name or a specific object to the method and the
  #             method will control the user experience. 
  #   
  #   Examples of methods in this section:
  #          -   Show the user all of this Class's objects from the database screen
  #          -   Create a menu from all of a Class's objects from the database and requires the user to 
  #              pick one.
  #          -   Create a menu of all this object's instance variables and requires the user to pick one. 
  ###############################
  
  # displays all this object to thesreen screen
  #
  # args - Array containing class_name in first slot and next method to call in its second slot
  #
  # calls next method
  def show_object(args)
    class_name  = args[0]
    next_method_to_call = args[1]
    puts class_name.all
    call_method(next_method_to_call)
  end

  # accepts a Class and returns an instance of the object from the database that the user selects
  #
  # class_object - Class, like Student
  #
  # returns an instance of the object
  def user_choice_of_object_in_class(class_object)
    create_menu = Menu.new("Which #{class_object.name} do you want to look up?")
    all = class_object.all
    all.each_with_index do |object, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: object.to_s, do_if_chosen:    
        [object]})
    end
    return run_menu(create_menu)[0]
  end
  
  # returns the field name that the user wants to change
  #
  # returns a String of the field name
  def user_choice_of_field(object)
    
    fields = object.database_field_names
    create_menu = Menu.new("Which field do you want to update?")
    fields.each_with_index do |field, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, do_if_chosen:    
      [field]})
    end
    run_menu(create_menu)[0]
  end
  
  # returns this object's data type
  #
  # returns a String or False if it cannot be found
  def type_of_field_in_database(class_name, field_name)
    all_fields = class_name.get_table_info
    all_fields.each do |field|
      if field["name"] == field_name
        return field["type"]
      end
    end
    false
  end
  
  # meant to be run with a block
  # tries to update the database or sends the user an error message
  #
  # returns nothing
  def try_to_update_database
    begin
      yield
      puts "Saved to the database."
    rescue Exception => msg
      puts "Not saved: #{msg}"
    end
  end

  #example of a menu method that you should create in your Driver class to use the methods below.
  #
  # calls the main menu
  # def main_menu
#       main = Menu.new("What would you like to work on?")
#       main.add_menu_item({key_user_returns: 1, user_message: "Work with movies.", do_if_chosen:  ["movie_menu"]})
#       main.add_menu_item({key_user_returns: 2, user_message: "Work with theatres.", do_if_chosen: ["theatre_menu"]})
#       main.add_menu_item({key_user_returns: 3, user_message: "Schedule movie time slots by theatre.", do_if_chosen: ["loc_time_menu"]})
#       main.add_menu_item({key_user_returns: 4, user_message: "Run an analysis on my theatres.", do_if_chosen: ["analyze_menu"]})
#       run_menu_and_call_next(main)
#   end
  
end
# Example code of how you might use this module in your Driver class
# Create a  new instance of your Driver class and call the method that has your first menu

# c = Driver.new
#
# puts c.main_menu

