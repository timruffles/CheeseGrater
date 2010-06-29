require 'ostruct'
require 'optparse'

# docs: http://www.ensta.fr/~diam/ruby/online/ruby-doc-stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
module CheeseGrater
  
  class Cli
    
    include Logging
    
    define_exception :CliError
    
    Version = [0,1]
    
    def run args
      
      begin
      
        #puts args.inspect
        args = read_options args
        #puts args.inspect
        
        p @options

        loader = Loader.new
      
        #p @options

        (files = args).each do |file|
          path = Pathname.new(file)
          config = YAML.load_file(path.absolute? ? path.realpath : "#{Dir.getwd}/#{path}")
          logger.info "Loaded #{file.split('/').pop}" if config
          loader.load_scrapers config
        end
        
        #p @options
        #exit
      
        logger.info "Found #{loader.root_scrapers.length} root scrapers"
        runner.run loader.root_scrapers
      
        raise CliError.new("No config file specified") if files.length == 0 
        
      rescue CliError => e
        logger.error e
      rescue Exception => e  
        logger.error e
      end
      
    end
    
    protected
    
    def runner
      @runner ||= Runner.create(@options.runner || 'single')  # todo, why isn't this setting in options?
    end
    
    def logger
      # ensure root logger also logs to stdout
      super
      @logger.add Outputter.stdout unless @logger.outputters.include? Outputter.stdout
      @logger
    end
    
    def read_options args
      options               = OpenStruct.new {
        runner = 'single'
      }

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: grater [options] [<file>]"

        opts.separator ""
        opts.separator "Options:"
        
        opts.on("-r", "--runner [RUNNER]", "Specify which runner to use to run scrapers") do |r|
          options.runner = r
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
      @options = options
      args
    end
  end
end
