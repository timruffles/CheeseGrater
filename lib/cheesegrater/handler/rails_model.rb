module CheeseGrater
  module Handler
    class RailsModel
      
      def run 
        Event.reflect.relationships
        Event.create Vo.fields
      end
      
      attr_accessor :vo
      
    end
  end
end