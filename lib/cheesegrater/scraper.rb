module CheeseGrater
  class Scraper
    
    class << self
      def create
        
      end
    end
    
    def scrape &block
      
      @pager.each_page(@request,@response) do |response|
        response.run &block
      end
      
    end
    
  end
end