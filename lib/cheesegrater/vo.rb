module CheeseGrater
  # Vo holds all the tasty data scraped by CheeseGrater.
  class Vo
    
    class << self
      def create_all config
        config.each_pair.inject([]) do |vos, (name, setup)|
          vos << Vo.new config.merge({:name => name})
        end
      end
    end
    
    def initialize setup
      @related_to = setup[:related_to]
      @fields     = setup[:fields]
      @name       = setup[:name]
      @handler    = setup[:handler]
    end
    
    attr_reader :name, :handler
    attr_accessor :fields, :related_to
  end
end