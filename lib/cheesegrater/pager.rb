module CheeseGrater
  class Pager
    
    include Configable
    
    class << self
      def create config = {}
        p = Pager.new
        p.setup config || {}
        p
      end
    end
      
    
    # page a request, yielding the raw responses generated
    def page request
      
      # page all other pages as long as they're required
      response = false
      has_run = false
      while true
         # prepare the request, allowing the first run even if no setup if provided
         setup = read_fields_and_setup(response)
         break if has_run && setup.empty?
         
         request.setup(setup)
         response = yield request.run
         
         has_run = true
      end
      
    end
    
    # fields for the request
    attr_accessor :page_no, :items_per_page
    # fields for reading the response
    attr_accessor :next_page_complete_endpoint, :items_on_page_path
    
    
    protected
    
    def current_page 
      (@current_page ||= 1)
    end
    
    # reads the response to yield any fields to merge into the existing request,
    # or setup hashes if the request needs to change more completely
    def read_fields_and_setup response = false
      
      setup = {}
      
      # list of blocks that, combined, represent the setup of the next request
      setup_blocks = {
        
        # page_no, move to next?
        :page_no => lambda do |response|
          if response && response.scalar_query(self[:items_on_page_path]) > 0
            setup[:fields][:page_no] = current_page += 1
          end
        end,
        
        # endpoint: must come last, as replaces all request fields
        :next_page_complete_endpoint => lambda do |response|
          if response && endpoint = response.scalar_query(self[:next_page_complete_endpoint])
            # no other fields required
            setup = {:endpoint => endpoint, :fields => {}}
          end
        end
      }
      
      setup_blocks.each do |setup_related_key, setup_block|
        setup_block.call(response) if self[setup_related_key]
      end
      
      setup
    end
    
    
  end
end