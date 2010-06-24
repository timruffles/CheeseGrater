module CheeseGrater
  class Scraper

    class << self
      def create setup, related_scrapers = {}
        Scraper.new Request.create_all(setup[:request]),
                    Response.create(setup[:response]),
                    Vo.create_all(setup[:vos]),
                    Pager.create(setup[:pager]),
                    setup[:root],
                    related_scrapers
      end
    end

    def initialize requests, response, vos, pager, root, related_scrapers = {}
      @requests         = requests
      @response         = response
      @vos              = vos
      @related_scrapers = related_scrapers
      @root             = root
      @pager            = pager
    end

    def run

      make_requests @requests, @pager do |raw_response|

        @response.raw = raw_response
        s
        read_response @vos, @response, @related_scrapers do |scraped|
          yield scraped
        end

      end

    end
    
    def root?
      @root
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

        # setup all related scrapers
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
    end

  end
end
