# default rake blah
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require "resque"

# load cheesegrater lib classes! (otherwise resque workers will FAILLLL)
#lib_dir = File.dirname(__FILE__) + "/lib/"
#require lib_dir + 'cheesegrater'

# load cheesy lib tasks
lib_tasks_dir = File.dirname(__FILE__) + '/lib/tasks'
Dir["#{lib_tasks_dir}/*.rake"].each { |f| load(f) }

# resque tasks
require 'resque/tasks'