module CheeseGrater
  # Vo holds all the tasty data scraped by CheeseGrater.
  class Vo
    
    class << self
      def create_all config
        return {} unless Hash === config
        config.inject([]) do |vos, (name, setup)|
          vos << Vo.new(setup.merge({:name => name}))
        end
      end
      
      def create config = {}
        Vo.new config
      end
    end
    
    def initialize setup = {}
      @related_to = setup[:related_to] || {}  # list of other VOs that need to be associated on save
      @fields     = setup[:fields] || {}      # class attributes
      @name       = setup[:name]              # class name of VO
      @handler    = setup[:handler]           # what class name to save 
      @item_path  = setup[:item_path]         # xpath/other document query

    end
    
    attr_reader :name, :handler, :item_path
    attr_accessor :fields, :related_to
  end
end