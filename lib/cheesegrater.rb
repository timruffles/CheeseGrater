require 'rubygems'
require 'kwalify'

lib_dir = File.dirname(__FILE__)
require lib_dir + '/cheesegrater/coreextensions'
require lib_dir + '/cheesegrater/logging'
Dir.glob(lib_dir + '/cheesegrater/**/*.rb') {|f| require f unless File.directory? f}