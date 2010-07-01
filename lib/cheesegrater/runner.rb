require "resque"
require "yaml"

module CheeseGrater
  module Runner
    # same as self.create (module factory class - acts like send)
    class << self
      def create runner
        const_get(runner.capitalize).new
      end
    end

    class Base      
      attr_accessor :handlers      

      def handle task
        handlers[task.class].call(task, &block)
      end
      
      # saves an Vo as a model
      def save
        
      end
    end
    
    # class Specgenerator < Base
    #   
    #   include Util::TestGenerator
    #   
    #   def run que
    #     vos = []
    #     while task = que.shift
    #       
    #       next if task.respond_to? :fields
    #       
    #       Specgenerator.create(task)
    #       
    #       task.run do |yielded|
    #         que << yielded
    #       end
    #     end
    #     
    #   end
    #   
    # end
    
    # single threaded - will have to load db enviroment to save found VOs
    class Single < Base
      
      def run que
        vos = []
        while task = que.shift
          
          vos << task if task.respond_to? :fields
          next if task.respond_to? :fields
          
          task.run do |yielded|
            que << yielded
          end
        end
        
        puts vos.to_yaml
      end   
    end
    
    class Resque
      
      include Logging
      
      @queue = :scrape
      
      def logger
        GraterLogger.add Outputter.rolling_outputter unless GraterLogger.outputters.include? Outputter.rolling_outputter
      end

      # RUN ROOT SCRAPERS, ADD TO :SCRAPER QUEUE
      # que = list of root scrapers
      def run que
        que.each do |scraper|       
          # :: = global context
          ::Resque.enqueue(CheeseGrater::Runner::Resque, YAML::dump(scraper))
        end
        
        puts vos.to_yaml
      end
    
      def self.perform(serialised_scraper)
        scraper = YAML::load(serialised_scraper)
        puts "scraping..."
        scraper.run do |scraped|
          if scraped.respond_to?("fields")
            p "VO: #{scraped.inspect}" 
            ::Resque.enqueue(CheeseGrater::Handler::RailsModel, YAML::dump(scraped))
          else
            p "SCRAPER: #{scraped.inspect}"
            ::Resque.enqueue(CheeseGrater::Runner::Resque, YAML::dump(scraper))
          end
        end
        puts ""
      end
    end
  end
end