module CheeseGrater 
  module Response
    class Base
      
      # performs a query in scope, and returns an array of results
      def query(query, scope = @document)
        raise "Implement"
      end
      
      # performs a query in scope, and returns a single, scalar result
      def scalar_query(query, scope = @document)
        raise "Implement"
      end
      
      attr_reader :document, :raw
      
    end
  end
end