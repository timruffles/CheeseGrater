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
      
      # takes a query that'll yield a set of items, and a hash of fields to fill in by querying each item found, from an intial_scope
      def hash_query(fields_to_queries, scope = @document)
        raise "Implement"
      end
      
      attr_reader :document, :raw
      
    end
  end
end