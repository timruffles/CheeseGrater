module CheeseGrater
  class Pager
    
    class << self
      def create setup
        Pager.new
      end
    end
    
    def page
      
      first_page_response = yield({})
      while fields = read_fields(first_page_response)
         yield fields
      end
      
    end
    
  end
end