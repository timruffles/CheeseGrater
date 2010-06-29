module CheeseGrater 
  module Response
    class Base
      
      # return items selected by query
      def items item_path, fields
        yield format_fields({})
      end
      
      def value value_path
        
      end
      
      attr_reader :raw
      
    end
  end
end