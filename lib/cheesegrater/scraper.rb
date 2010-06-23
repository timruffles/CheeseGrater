module CheeseGrater
  class Scraper
    
    class << self
      def create
        
      end
    end
    
    def initialize setup
    end
    
    def run

      @pager.each_page(@request,@response) do |response|
        
        @vos.each_pair do |name, vo_setup|
          
          @response.query(vo_setup[:item_path]) do |item|
            
            # setup all data
            vo = Vo.new name, vo_setup
            vo_setup[:fields].each do |field|
              vo.add(field, @response.query(field, item))
            end
            
            yield vo
          
            # setup all dependent scrapers
            vo_setup[:related_to].each_pair do |name, related|
              scraper = get_scraper(name)
              @fields.each do |field|
                scraper.add_request_field(field, @response.query(field))
              end
              scraper.related_to = vo
            
              yield scraper
              
            end
          end
        end
      end

    end
    
    private
    
    def get_scraper name
      @scrapers[name]
    end
    
  end
end