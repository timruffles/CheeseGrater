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
      
      # TODO should really be replaced with kwalify functionality
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
    
    # TODO think about how this could be simplified - probably Kwalify again
    def initialize setup
      @requests         = setup[:requests]
      @response         = setup[:response]
      @vos              = setup[:vos]
      @related_scrapers = setup[:related_scrapers] || {}
      @is_root          = setup[:is_root] 
      @pager            = setup[:pager] || {}
      @scrapers         = setup[:scrapers] || {}
      @name             = setup[:name]
      
      # load in a named helper for this scraper, or the base one
      if @name && Helper.const_defined?(@name)
        @helper = Helper.const_get(@name).new
      else 
        @helper = Helper::Base.new
      end
      
    end

    def run
      logger.info "#{self.name} running"
      
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
      
    rescue Exception => e
      logger.error e
    end
    
    def is_root?
      @is_root
    end
    
    def get_vo name
      vos.each do |vo|
        return vo if vo.name == name
      end
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
      def read_response vos, response, related_scrapers = {}, scrapers = {}, &yielder
      
        logger.info("Trying to find #{vos.length} vos") if vos.length > 0
      
        # retrieve all items and yield vos, and any related vos
        vos.each do |vo|
          response.query(vo.item_path).each do |item_scope|
          
            # TODO this is a bit awkward, there is logic around whether a VO's field should
            # be fulfilled from a query, or from some other part of program state, like the scraper
            found_vo_fields = perform_data_requests(response, vo.fields, item_scope)
          
            # for each set of VO fields found in the response
            # create a new instance of the vo, and give it a uuid
            found_vo        = vo.deep_clone
            found_vo.fields = @helper.format_vo_fields(found_vo.name,found_vo_fields)
            found_vo.fields.merge!({:uuid => Scraper::UUID_GEN.generate})
          
            logger.info("Found a #{vo.name} Vo")
          
            setup_relations!(found_vo, item_scope, related_scrapers, response, &yielder)
            
            # yield up that VO goodness!
            yielder.call(found_vo)
          end

        end
      
        # retrieve all the scrapers that are unrelated to VOs
        read_scrapers(scrapers, related_scrapers, response, &yielder)
      end
    
      # gets all the data for a hash of keys to queries
      def perform_data_requests response, request_hash, scope
      
        result = {}
        request_hash.each_pair do |key, setup|
            # hash
          result[key] = 
            if setup.respond_to? :keys
              if try_each = setup[:try_each]
                value = nil
                try_each.any? do |query|
                  value = perform_field_query(query, response, scope)
                end
                value
              else
                raise "Unknown field setup for #{key}: #{setup.inspect} in #{request_hash.inspect}"
              end
          
            # scalar or array
            else
              perform_field_query(setup, response, scope)
            end
        
        end
      
        result
      end
      
      # performs the scalar query on a field, deadling with any special methods for making it
      def perform_field_query query, response, scope
        if Array === query
          case query.first
            when :method # a method call
              query.shift
              return eval(query.join('.'))
            when :literal # a literal value
              return query.last
          end
        end
        response.scalar_query(query, scope)
      end
    
      # sets up a VOs relation_to objects in place, yielding all related scrapers rather than including
      # them in the VO
      def setup_relations! the_vo, vo_scope, related_scrapers, response
      
        the_vo.related_to.each_pair do |name, related_setup|
        
          # two possibilities: either we have all the data we need on this page, or we'll need another scrape:

          # 1   in the first we relate the the_vo.to the actual the_vo.we create with that data
          relation_handler = nil # this will be called once for each time the related thing is found
          if is_scraper? name.to_s
        
            # at mo, just need the first part of the name, the Scraper which is unique
            # TODO need to allow for full paths
            related_scraper_name, related_vo_name = name.to_s.split('::')
            scraper                               = related_scrapers[related_scraper_name.to_sym].deep_clone
          
            relation_handler = lambda do |fields|
               logger.info("Yielding #{scraper.class} to scraper related vo")
             
               scraper.requests.each {|r| r.fields.merge!(@helper.format_scraper_fields(name,fields))}
               scraper.get_vo(related_vo_name.to_sym) \
                      .related_to.merge!(the_vo.name => the_vo.fields[:uuid])
               yield scraper
            end
        
          # 2   in the second case we relate the scraper's the_vo.back to this the_vo. with this the_vo.s UUID
          else
          
            # create and setup the related vo, storing it in the_vo
            related_vo = Vo.create(related_setup.merge(:name => name))
            #p the_vo.related_to, related_vo, related_setup
            #exit
            relation_handler = lambda do |fields|
              logger.info("Relating #{name} Vo to #{the_vo.name}")
            
              found_related_vo        = related_vo.deep_clone
              found_related_vo.fields.merge!(@helper.format_related_vo_fields(found_related_vo.name,fields))
              the_vo.related_to[name] = found_related_vo
            end
        
          end
        
          # are we querying the whole document, or just the item's scope?
          scopes = if related_setup[:item_path]
                    response.query(related_setup[:item_path])
                   else
                    [vo_scope]
                   end
                 
         scopes.each do |scope|
           relation_handler.call(perform_data_requests(response, related_setup[:fields], scope))
         end
       
        end
      
      end
    
      # creates and yields all scrapers found in response
      def read_scrapers scrapers, related_scrapers, response
      
        logger.info("Trying to find #{scrapers.length} scrapers") if scrapers.length > 0
      
        # create and yield all scrapers found
        scrapers.each_pair do |name, scraper_setup|
          response.query(scraper_setup[:item_path]).each do |item_scope|
          
            scraper        = related_scrapers[name].deep_clone
            scraper_fields = perform_data_requests(response, scraper_setup[:fields],item_scope)

            # TODO it should make request fields into sets (eg, no repeated fields)
            scraper.requests.each do |request| 
              request.fields.merge!(scraper_fields)
            end
          
            # yield the finished scraper
            logger.info("Yielding a #{scraper.name} scraper found with #{scraper_setup[:item_path]}")
            yield scraper
          end
        end

      end
    
      # determinies whether a name, from a related_to field, is another scraper, or a VO
      def is_scraper? name
        name.include? '::'
      end

  end
  
end
