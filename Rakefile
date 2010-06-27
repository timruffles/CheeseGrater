# default rake blah
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# load cheesy lib tasks
lib_tasks_dir = File.dirname(__FILE__) + '/lib/tasks'
Dir["#{lib_tasks_dir}/*.rake"].each { |f| load(f) }

# resque tasks
require 'resque/tasks'