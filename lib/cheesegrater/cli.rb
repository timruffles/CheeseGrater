require 'ostruct'
require 'optparse'

# docs: http://www.ensta.fr/~diam/ruby/online/ruby-doc-stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
module CheeseGrater
  
  class Cli
    
    include Logging
    
    # cli logger logs before the main grater_log is setup, and
    # in debug mode outputs to stdout
    CLI_LOGGER_NAME = 'grater_cli_log'
    CLI_LOGGER = Logger.new(CLI_LOGGER_NAME)
    CLI_LOGGER.outputters = Log4r::Outputter['stderr']
    
    define_exception :CliError
    
    Version = [0,1]
    
    def run args
      args = read_options args
      
      CLI_LOGGER.outputters = [Log4r::Outputter['stdout'], Log4r::Outputter['stderr']] if @options.debug
      
      loader = Loader.new
      
      # loads in each file specified, actually allowing config to be overridden if it comes later in the chain
      (files = args).each do |file|
        
        CLI_LOGGER.info("Loaded #{file}")
        
        path = Pathname.new(file)
        config = YAML.load_file(path.absolute? ? path.realpath : "#{Dir.getwd}/#{path}")
        
        # load in all outputters
        config['log4r_config']['loggers'].each do |logger|
          if logger['name'] == LOGGER_NAME
            logger['outputters'] += @options.outputters
          end
        end if config['log4r_config'] && @options.outputters.length > 0

        loader.load config
      end
      
      CLI_LOGGER.info "Found #{loader.root_scrapers.length} root scrapers, running:"
      runner.run loader.root_scrapers
      
      raise CliError.new("No config file specified") if files.length == 0 
      
    rescue CliError => e
      CLI_LOGGER.error e
    rescue Exception => e
      CLI_LOGGER.error e
    end
    
    protected
    
    def runner
      @runner ||= Runner.create(@options.runner || 'single')  # TODO, why isn't this setting in options?
    end
    
    def read_options args
      
      options = OpenStruct.new({
        :runner => 'single',
        :outputters => '',
        :debug => false
      })

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: grater [options] [<file>]"

        opts.separator ""
        opts.separator "Options:"
        
        opts.on("-r", "--runner [RUNNER]", "Specify which runner to use to run scrapers") do |r|
          options.runner = r
        end
        
        opts.on("-d", "--debug", "Set debug, all output goes to stdout, verbosity increased") do
          options.debug = true
        end
        
        opts.on("-o", "--outputters [OUTPUTTERS]", "Specify which outputters will be used") do |o|
          options.outputters = o.split(/, ?/)
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
