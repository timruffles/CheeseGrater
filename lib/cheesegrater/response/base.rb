module CheeseGrater 
  module Response
    class Base
      # TODO this is hard to use to requery in item context, rewrite!
      # return items selected by query
      def items item_path, fields, item
        yield format_fields({})
      end
      
      def value value_path
        
      end
      
      attr_reader :raw
      
    end
  end
end