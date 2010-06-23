require 'log4r'

module CheeseGrater
  module Logging
    
    include Log4r

    GraterLog = Logger.new('graterlog')
    
    # access class's logger
    def logger
      # allow override: if instance has logger set already, will use that instead of global
      unless @logger
        @logger = GraterLog
      end
      @logger
    end
  end
end