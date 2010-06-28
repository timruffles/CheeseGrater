desc 'Load cheesy lib classes'
task :environment do
  puts "Loading cheesegrater environment..."
  # load cheesegrater lib classes! (otherwise resque workers will FAILLLL)
  lib_dir = File.dirname(__FILE__) + "/../../lib/"
  require lib_dir + 'cheesegrater'
end

desc 'Load rails env'
task :rails do
  puts "Loading rails environment..."
  # load cheesegrater lib classes! (otherwise resque workers will FAILLLL)
  ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'  
  require File.expand_path(File.dirname(__FILE__) + "/../../../appq/config/environment")
end