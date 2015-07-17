ActiveRecord::Base.establish_connection(
  :adapter => "sqlite",
  :database  => "movies.db"
)

unless ActiveRecord::Base.connection.table_exists?(:ratings)
  ActiveRecord::Base.connection.create_table :ratings do |t|
    t.string :name
  end  
end

unless ActiveRecord::Base.connection.table_exists?(:studios)
  ActiveRecord::Base.connection.create_table :studios do |t|
    t.string :name
  end  
end

unless ActiveRecord::Base.connection.table_exists?(:time_slots)
  ActiveRecord::Base.connection.create_table :time_slots do |t|
    t.string :time_slot
  end  
end


unless ActiveRecord::Base.connection.table_exists?(:movies)
  ActiveRecord::Base.connection.create_table :movies do |t|
    t.string :name
    t.string :description
    t.length :integer
    t.studio_id :integer
    t.rating_id :integer
  end  
end

unless ActiveRecord::Base.connection.table_exists?(:locations)
  ActiveRecord::Base.connection.create_table :locations do |t|
    t.string :name
    t.integer :num_staff
    t.integer :num_seats
    t.integer :num_time_slots
  end  
end

unless ActiveRecord::Base.connection.table_exists?(:location_times)
  ActiveRecord::Base.connection.create_table :location_times do |t|
    t.integer :movie_id
    t.integer :time_slot_id
    t.integer :location_id
    t.integer :num_tickets_sold
  end  
end