module CheeseGrater
  class DanScraper
    @queue = :scrape
    
    def self.perform(i)
      app_lib_dir = File.dirname(__FILE__) + "/../../../appq/lib/"
      require app_lib_dir + 'importer'
      puts "scraper ##{i} start"
      # sleep 5
      Resque.enqueue(App::Importer, {:event => :object})
      puts "scraper ##{i} end"
    end
  end
end