module CheeseGrater 
  
  # Abstracts the response object which contains the data to scrape.
  module Response
    class << self
      
      def create setup
        const_get(setup[:type]).new
      end
      
    end
    
  end
end
