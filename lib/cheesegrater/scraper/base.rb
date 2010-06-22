module CheeseGrater
  module Scraper
    class Base
      
      def scrape &block

        @pager.each_page(@request,@response) do |response|
        end

      end
      
    end
  end
end
