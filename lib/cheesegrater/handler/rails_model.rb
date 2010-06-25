module CheeseGrater
  module Handler
    class RailsModel
      
      def run 
        
        model = const_get(Vo.name).build Vo.fields
        
      end
      
      attr_accessor :vo
      
    end
  end
end