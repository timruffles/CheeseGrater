require 'ostruct'
require 'optparse'
require 'log4r'

module CheeseGrater
  class Cli
    
    include Log4r
    
    Version = [0,1]
    
    def run
      
      options = read_options
      
      raise if files.length == 0 
      (files = ARGV).each do |file|
        
      end
      
      
      
    end
    
    def logger
      unless @logger
        logger = Logger.new 'grater_cli' 
        logger.outputters = Outputter.stdout
      end
      @logger ||= logger
    end
    
    def read_options
      options               = OpenStruct.new {
        runner = 'single'
      }

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: grater [options] [<file>]"

        opts.separator ""
        opts.separator "Options:"
        
        opts.on("-r", "--runner", "Specify which runner to use to run scrapers") do
          exit
        end
        
        opts.separator ""
        opts.separator "Utility:"

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        
        # Another typical switch to print the version.
        opts.on_tail("--version", "Show version") do
          puts Version.join('.')
          exit
        end
        
      end
      
      opts.parse!(ARGV)
      options
    end
  end
end
