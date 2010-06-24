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
        
        while que.length
          
          task = que.shift
          
          task.run do yielded
            que << yielded
          end
          
        end
      end
      
    end
  end
end