namespace :data do
  desc "Load static data from db/data into the database.  Use DB_STATIC_TABLES=x,y to load specific table(s)."
  task :load => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
    (ENV['DB_STATIC_TABLES'] ? ENV['DB_STATIC_TABLES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'data', '*.{yml,csv}'))).each do |fixture_file|
      Fixtures.create_fixtures('db/data', File.basename(fixture_file, '.*'))
    end
  end
end
