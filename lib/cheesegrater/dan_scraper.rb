module CheeseGrater
  class DanScraper
    @queue = :scrape
    
    def self.perform(i)
      app_lib_dir = File.dirname(__FILE__) + "/../../../appq/lib/"
      require app_lib_dir + 'importer'

      # slow this baby down a bit
      sleep 5

      params = {:event => :object}
      Resque.enqueue(App::Importer, params)
      puts "scraper (#{i}) -> saver (#{params})"
    end
  end
end