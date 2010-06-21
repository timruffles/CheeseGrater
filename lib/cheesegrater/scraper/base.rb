module CheeseGrater
  module Scraper
    class Base
      def scrape &block

        @pager.each_page(@request,@response) do |response|
          response.run &block
        end

      end
    end
  end
end
