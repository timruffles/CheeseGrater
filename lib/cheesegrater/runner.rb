module CheeseGrater
  module Runner
    
    class << self
      
      def create runner
        const_get(runner.capitalize).new
      end
      
    end
    
    class Base
      
      def handle task
        handlers[task.class].call(task, &block)
      end
      
      # saves an Vo as a model
      def save
        
        
      end
      
      attr_accessor :handlers
      
    end
    
    # single threaded - will have to load db enviroment to save found VOs
    class Single < Base
      
      def run que
        
        while task = que.shift
          
          puts task.to_yaml if task.respond_to? :fields
          next if task.respond_to? :fields
          
          task.run do |yielded|
            que << yielded
          end
          
        end
      end
      
    end
  end
end