# default rake blah
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# load cheesegrater lib classes! (otherwise resque workers will FAILLLL)
lib_dir = File.dirname(__FILE__) + "/lib/"
require lib_dir + 'cheesegrater'

# resque tasks
require 'resque/tasks'