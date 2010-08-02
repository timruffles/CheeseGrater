require 'rubygems'
require 'log4r'
require 'log4r/yamlconfigurator'

module CheeseGrater
  module Logging
    
    include Log4r
    
    LOGGER_NAME = 'grater_log'
    
    # TODO setup diff enviroments so this isn't run by testing
    # RollingFileOutputter.new("rolling_outputter", {
    #   "filename" => File.dirname(__FILE__) + "/log/grater.log",
    #   "maxsize" => 16000
    # })
    
    # access class's logger
    def logger
      # allow override: if instance has logger set already, will use that instead of global
      Logger[LOGGER_NAME] || Logger['root']
    end
  end
end