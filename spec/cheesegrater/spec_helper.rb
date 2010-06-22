require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

root = File.dirname(__FILE__) + '/../../lib/'
require root + '/cheesegrater'
