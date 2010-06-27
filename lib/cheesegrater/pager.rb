module CheeseGrater
  class Pager
    
    class << self
      def create setup
        pager = Pager.new
        setup.each_pair do |name, val|
          pager.send("#{name}=".to_sym,val)
        end
        pager
      end
    end
    
    def page
      
      # first page
      response = yield({})
      
      # all other pages
      while read_fields(response) != {} 
         response = yield 
      end
      
    end
    
    
    attr_accessor :next_page_url_path
    
    protected
    
    
    def read_fields response
      fields = {}
      pager_fields = {
        :endpoint => :next_page_url_path
      }
      pager_fields.each_pair do |field_to_yield, path_accessor|
        
        field_path = self.send path_accessor
        value = response.value(field_path) if field_path
        next unless value
        fields[field_to_yield] = value
        
      end
      fields
    end
    
    
  end
end