module CheeseGrater
  class Pager
    
    include Configable, Logging
    
    class << self
      def create config = {}
        p = Pager.new
        p.setup config || {}
        p
      end
    end
      
    
    # page a request, yielding the raw responses generated
    def page request
      logger.info "Pager starting:"
      # page all other pages as long as they're required
      response = false
      has_run = false
      while true
         # prepare the request, allowing the first run even if no setup if provided
         setup, fields = read_fields_and_setup(response)
         break if has_run && @continue == false
         
         request.setup(setup)
         request.fields.merge!(fields)
         response = yield request.run
         
         has_run = true
      end
      
      logger.info "Pager finished."
    end
    
    # fields for the request
    attr_accessor :page_no
    # fields for reading the response
    attr_accessor :next_page_complete_endpoint, :items_on_page_path
    
    attr_writer :current_page
    
    protected
    
    def current_page 
      @current_page ||= 1
    end
    
    
    # reads the response to yield any fields to merge into the existing request,
    # or setup hashes if the request needs to change more completely
    def read_fields_and_setup response = false
      
      @continue = false
      setup = {}
      fields = {}
      
      # list of blocks that, combined, represent the setup of the next request
      setup_blocks = {
        
        # page_no, move to next?
        :page_no => lambda do |response|
          if response && response.scalar_query(items_on_page_path).to_i > 0
            fields[page_no] = (self.current_page += 1)
            @continue = true
            logger.info "Paging to page no #{self.current_page}"
          elsif response && response.scalar_query(items_on_page_path).to_i == 0
            logger.info "That's all folks, no more items" if response
          end
        end,
        
        # endpoint: must come last, as replaces all request fields
        :next_page_complete_endpoint => lambda do |response|
          if response && endpoint = response.scalar_query(next_page_complete_endpoint)
            # no other fields required
            setup = {:endpoint => endpoint, :fields => {}}
            @continue = true
            logger.info "Paging to complete endpoint, #{endpoint}"
          end
        end
      }
      
      setup_blocks.each do |setup_related_key, setup_block|
        setup_block.call(response) if self[setup_related_key]
      end
      
      [setup, fields]
    end
    
    
  end
end