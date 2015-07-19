module MenuHelper
  def slash_to_class_names
    {"theatre" => Location, "location_time" => LocationTime, "movie" => Movie, "time" => TimeSlot, "studio" => Studio, "rating" => Rating, "location" => Location}
  end
end