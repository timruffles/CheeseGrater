module CheeseGrater
  class Scraper

    class << self
      def create setup, related_scrapers = {}
        Scraper.new :requests         => Request.create_all(setup[:request]),
                    :response         => Response.create(setup[:response]),
                    :vos              => Vo.create_all(setup[:response][:vos]),
                    :pager            => Pager.create(setup[:pager]),
                    :is_root          => setup[:root],
                    :related_scrapers => related_scrapers,
                    :scrapers         => setup[:scrapers]
      end
    end

    def initialize setup
      @requests         = setup[:requests]
      @response         = setup[:response]
      @vos              = setup[:vos]
      @related_scrapers = setup[:related_scrapers]
      @is_root          = setup[:is_root]
      @pager            = setup[:pager]
      @scrapers         = setup[:scrapers]
    end

    def run

      make_requests @requests, @pager do |raw_response|
        @response.raw = raw_response
        
        read_response @vos, @response, @related_scrapers, @scrapers do |scraped|
          yield scraped
        end

      end

    end
    
    def is_root?
      @is_root
    end
    
    attr_accessor :requests, :response, :vos, :pager, :is_root, :related_scrapers, :scrapers
    
    
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
    def read_response vos, response, related_scrapers = {}, scrapers = {}
      
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
          response.items(vo.item_path, related_setup[:fields]) do |fields|
            scraper.request.fields.merge!(fields)
            scraper.related_to = vo
            yield scraper
          end
          
        end

      end
      
      # TODO this is an interesting bit - how should this scraper be setup and run,
      # at the mo, a hash is passed in and the scraper sets it up
      # create and yield all related scrapers
      
      # TODO the way the requests are made is making this a big ugly - the requests.each etc, is it
      # okay to assume it's appropriate to do that? probably in this context: request with multiple 
      # dates, for instance, will still need to request all dates to access the full dataset with the
      # additional filter scraped from the response
      scrapers.each_pair do |name, scraper_setup|
        
        response.items(scraper_setup[:item_path], scraper_setup[:fields]) do |fields|
          scraper = related_scrapers[name].dup
          scraper.requests.each {|request| request.fields.merge!(fields)}
          yield scraper
        end

      end
    end

  end
end
