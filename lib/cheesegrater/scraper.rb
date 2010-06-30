require 'uuid'
module CheeseGrater
  class Scraper
    
    include Logging
    
    # get a UUID to identify the vo to the world
    # docs: http://github.com/assaf/uuid/tree/v2.3.1
    UUID.state_file = false
    
    # a single instance of the UUID generator
    UUID_GEN = UUID.new
    
    class << self
      def create setup, related_scrapers = {}
          Scraper.new :requests         => Request.create_all(setup[:request]),
                      :response         => Response.create(setup[:response]),
                      :vos              => Vo.create_all(setup[:response][:vos]),
                      :pager            => Pager.create(setup[:pager]),
                      :is_root          => setup[:root],
                      :related_scrapers => related_scrapers,
                      :scrapers         => setup[:scrapers],
                      :name             => setup[:name]
      end
    end

    def initialize setup
      @requests         = setup[:requests]
      @response         = setup[:response]
      @vos              = setup[:vos]
      @related_scrapers = setup[:related_scrapers] || {}
      @is_root          = setup[:is_root] 
      @pager            = setup[:pager] || {}
      @scrapers         = setup[:scrapers] || {}
      @name             = setup[:name]
      
      if @name && Helper.const_defined?(@name)
        @helper = Helper.const_get(@name).new
      else 
        @helper = Helper::Base.new
      end
      
    end

    def run
      
      logger.info "#{self.class} running"
      
      # take each request from make_requests(), and then pass the response
      # to read_response, yielding up the final result
      make_requests @requests, @pager do |raw_response|
        
        @response.raw = raw_response
        
        read_response @vos, @response, @related_scrapers, @scrapers do |scraped|
          # pass up the lovely cheese we've found!
          yield scraped
        end
        
        # return the response so that it can be passed back into the pager in make_requests()
        @response
      end

    end
    
    def is_root?
      @is_root
    end
    
    attr_accessor :requests, :response, :vos, :pager, :is_root, :related_scrapers, :scrapers, :name, :helper
    
    
    protected

    # make all paged requests, yielding the raw results from each
    def make_requests requests, pager

      requests.each do |request|

        # setup the request with the fields required to page
        pager.page(request) do |raw_response|
          
          # yield up response to the run() method, retrieve and return the response for the pager
          response = yield raw_response
          
        end

      end
    end
    
    # read all items from response
    def read_response vos, response, related_scrapers = {}, scrapers = {}
      # retrieve all items and yield vos, and any related vos
      vos.each do |vo|
        
        response.items(vo.item_path, vo.fields) do |found_vo_fields|
          
          # for each set of VO fields found in the response
          # create a new instance of the vo, and give it a uuid
          found_vo = vo.dup
          found_vo.fields = @helper.format_vo_fields(found_vo.name,found_vo_fields).merge({:uuid => Scraper::UUID_GEN.generate})
          
          # setup all related Vo scrapes
          found_vo.related_to.each_pair do |name, related_setup|
          
            # two possibilities: either we have all the data we need on this page, or we'll need another scrape
            # in the first we relate the found_vo.to the actual found_vo.we create with that data
            # in the second case we relate the scraper's found_vo.back to this found_vo. with this found_vo.s UUID
            if is_scraper? name.to_s
            
              # at mo, just need the first part of the name, the Scraper which is unique
              # TODO need to allow for full paths
              related_scraper_name, related_vo_name = name.to_s.split('::')
              scraper = related_scrapers[related_scraper_name.to_sym]
            
              response.items(related_setup[:item_path], related_setup[:fields]) do |fields|
                scraper.requests.each {|r| r.fields.merge!(@helper.format_scraper_fields(name,fields))}
                scraper.vos[related_vo_name.to_sym].related_to.merge!(found_vo.name => found_vo.fields[:uuid])
                yield scraper
              end
            
            else
            
              # create and setup the related vo, storing it in found_vo
              related_vo = Vo.create(related_setup.merge(:name => name))
              response.items(related_vo.item_path, related_vo.fields) do |related_vo_fields|
                found_related_vo = related_vo.dup
                found_related_vo.fields.merge!(@helper.format_related_vo_fields(found_related_vo.name,related_vo_fields))
                found_vo.related_to[name] = found_related_vo
              end
            
            end
          
          end
          
          yield found_vo
        
        end

      end
      
      # create and yield all scrapers found
      scrapers.each_pair do |name, scraper_setup|
        
        response.items(scraper_setup[:item_path], scraper_setup[:fields]) do |fields|
          
          scraper = related_scrapers[name].deep_clone
          
          # TODO it should make request fields into sets (eg, no repeated fields)
          scraper.requests.each do |request| 
            request.fields.merge!(fields)
          end
          yield scraper
        end

      end

    end

  end
  
  # determinies whether a name, from a related_to field, is another scraper, or a VO
  def is_scraper? name
    name.include? '::'
  end
  
end
