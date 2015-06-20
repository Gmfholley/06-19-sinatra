lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'theatre_manager.rb'
  s.version     = '0.0.0'
  s.date        = '2015-06-20'
  s.summary     = "Managers movies, theatres, and locations for a movie theatre owner."
  s.description = "Uses sqlite3 and minitests.  Creates and maintains a database."
  s.authors     = ["Gwendolyn Holley"]
  s.email       = 'gmfholley@gmail.com'
  s.files       = ["lib/theatre_manager.rb", "lib/theatre_manager/location.rb", "lib/theatre_manager/timeslot.rb", "lib/theatre_manager/database_connector.rb", "lib/theatre_manager/location_time.rb", "lib/theatre_manager/menu_item.rb", "lib/theatre_manager/menu.rb", "lib/theatre_manager/movie.rb", "lib/theatre_manager/rating.rb", "lib/theatre_manager/studio/rb"]
  spec.executables   = ['bin/theatre_manager.rb']
  spec.test_files    = ['tests/test_location.rb', 'tests/test_locationtimeslot.rb', 'tests/test_movie.rb', 'tests/test_rating.rb', 'tests/test_studio.rb', 'tests/test/timeslot.rb']
  s.homepage    = ''
  s.license     = ''
end