module CheeseGrater
  class DanScraper
    @queue = :scrape
    
    def self.perform(i)
      # need to load class before it can be queued
      require File.expand_path("../../../../appq/lib/backend/importer", __FILE__)
      
      # slow this baby down a bit
      #sleep 5
      
      params = {:event => Vo.new({})}
      Resque.enqueue(Backend::Importer, params)
      puts "scrape (#{i}) -> save (#{params})"
    end
  end
end