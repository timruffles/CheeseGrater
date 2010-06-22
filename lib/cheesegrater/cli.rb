require 'ostruct'
require 'optparse'
require 'log4r'

module CheeseGrater
  
  class Cli
    
    include Log4r
    
    define_exception :CliError
    
    Version = [0,1]
    
    def run args
      
      begin
      
        options = read_options args
      
        (files = args).each do |file|
          path = Pathname.new(file)
          config = YAML.load_file(path.absolute? ? path.realpath : "#{Dir.getwd}/#{path}")
          logger.info "Loaded #{file.split('/').pop}" if config
        end
      
        raise CliError.new("No config file specified") if files.length == 0 
        
      rescue CliError => e
        logger.error e
      rescue Exception => e  
        logger.error e
      end
      
    end
    
    def logger
      unless @logger
        logger = Logger.new 'grater_cli' 
        logger.outputters = Outputter.stdout
      end
      @logger ||= logger
    end
    
    def read_options args
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
      
      opts.parse!(args)
      options
    end
  end
end
