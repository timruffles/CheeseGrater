require 'log4r'
module CheeseGrater
  module Logging
    
    include Log4r

    GraterLog = Logger.new('graterlog')
    
    RollingFileOutputter.new("rolling_outputter", {
      "filename" => "log/grater.log",
      "maxsize" => 16000
    })
    
    # access class's logger
    def logger
      # allow override: if instance has logger set already, will use that instead of global
      @logger || GraterLog
    end
  end
end