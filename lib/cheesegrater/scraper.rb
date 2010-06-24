module CheeseGrater
  class Scraper

    class << self
      def create setup, related_scrapers = {}
        Scraper.new :requests         => Request.create_all(setup[:request]),
                    :response         => Response.create(setup[:response]),
                    :vos              => Vo.create_all(setup[:response][:vos]),
                    :pager            => Pager.create(setup[:pager]),
                    :is_root          => setup[:root],
                    :related_scrapers => related_scrapers
      end
    end

    def initialize setup
      @requests         = setup[:requests]
      @response         = setup[:response]
      @vos              = setup[:vos]
      @related_scrapers = setup[:related_scrapers]
      @is_root          = setup[:is_root]
      @pager            = setup[:pager]
    end

    def run

      make_requests @requests, @pager do |raw_response|
        @response.raw = raw_response
        
        read_response @vos, @response, @related_scrapers do |scraped|
          yield scraped
        end

      end

    end
    
    def is_root?
      @is_root
    end
    
    
    protected

    # make all paged requests, yielding the raw results from each
    def make_requests requests, pager

      requests.each do |request|

        # setup the request with the fields required to page
        pager.each_page_fields do |page_fields|
          
          request.fields.merge!(page_fields)
          request.run do |raw_response|
            yield raw_response
          end

        end

      end
    end

    # read all items from response
    def read_response vos, response, related_scrapers
      # retrieve all items and yield vos, and any related vos
      vos.each do |vo|
        response.items(vo.item_path, vo.fields) do |fields|
          to_yield = vo.dup
          to_yield.fields = fields
          yield to_yield

        end
        
        # setup all related Vo scrapes
        vo.related_to.each_pair do |name, related_setup|
         
          scraper = related_scrapers[name]
          #scraper.setup(scraper)
          related_setup[:fields].each do |field|
            scraper.request.fields[field] = response.query(field)
          end
          scraper.related_to = vo

          yield scraper
        end

      end
      
       # create and yield all related scrapers
      response[:scrapers].each_pair do |name, related_setup|
        
        scraper = related_scrapers[name]

        related_setup[:fields].each do |field|
          scraper.request.fields[field] = response.query(field)
        end

        yield scraper
      end
    end

  end
end
