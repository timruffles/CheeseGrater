desc 'Load cheesy lib classes'
task :environment do
  # load cheesegrater lib classes! (otherwise resque workers will FAILLLL)
  lib_dir = File.dirname(__FILE__) + "/../../lib/"
  require lib_dir + 'cheesegrater'
end