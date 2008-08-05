ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails/story_adapter'
require 'ruby-debug'

dir = File.dirname(__FILE__)
Dir[File.expand_path("#{dir}/steps/*.rb")].uniq.each do |file|
  require file
end

##
# Run a story file relative to the stories directory.

def run_local_story(filename, options={})
  run File.join(File.dirname(__FILE__), filename), options
end


def create_user(options = {})
  post :create, :user => {:login => 'quire',
                          :first_name => 'quentin',
                          :last_name => 'smith',
                          :email => 'quire@example.com',
                          :password => 'quire',
                          :password_confirmation => 'quire',
                          :sales_office => 1,
                          :role => 23}.merge(options)

end