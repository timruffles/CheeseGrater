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
    
    # single threaded - will have to load db enviroment to save found VOs
    class Single < Base
      
      def run que
        while task = que.shift
          puts task.to_yaml if task.respond_to? :fields
          next if task.respond_to? :fields
          
          task.run do |yielded|
            que << yielded
          end
        end
      end   
    end
    
    class Resque
      @queue = :scrape

      # RUN ROOT SCRAPERS, ADD TO :SCRAPER QUEUE
      # que = list of root scrapers
      def run que
        que.each do |scraper|       
          # :: = global context
          ::Resque.enqueue(CheeseGrater::Runner::Resque, YAML::dump(scraper))
        end
      end
    
      def self.perform(serialised_scraper)
        scraper = YAML::load(serialised_scraper)
        puts "scraping..."
        scraper.run do |scraped|
          if scraped.respond_to?("fields")
            p "IS VO: #{scraped.inspect}" 
            ::Resque.enqueue(CheeseGrater::Handler::RailsModel, YAML::dump(scraped))
          else
            p "IS SCRAPER: #{scraped.inspect}"
            ::Resque.enqueue(CheeseGrater::Runner::Resque, YAML::dump(scraper))
          end
        end
        puts ""
      end
    end
  end
end