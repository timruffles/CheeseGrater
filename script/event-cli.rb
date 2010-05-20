#!/usr/bin/env ruby
require 'Workers.rb'
require 'lib/Redis.rb'
w = Workers.new(Redis.new)

options = w.methods.select {|method| method != :initalize}
method  = ARGV[0]

if method == '-h'
  puts "Events-cli can be invoked with the following params:"
  puts options
else
  begin
    options[method]
  rescue Exception => e
    puts "Could not understand #{method}, maybe you meant one of the following?" 
    puts options
  end
end
