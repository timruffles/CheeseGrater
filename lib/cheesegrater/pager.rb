module CheeseGrater
  class Pager
    
    class << self
      def create setup
        Pager.new
      end
    end
    
    def each_page_fields
      
      yield({})
      
    end
    
  end
end