module CheeseGrater
  module Request
    class Base
      
      include Kwalify::Util::HashLike
      
      def intialize config = {}
        setup config
      end
      def run
        raise "Run needs to be implemented by subclass"
      end
      
      def setup config = {}
        
        config.each_pair do |k, v|
          self[k] = v
        end
        
      end

      attr_accessor :endpoint, :fields

    end
  end
end