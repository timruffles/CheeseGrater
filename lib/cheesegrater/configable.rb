module CheeseGrater
  module Configable
    
    include Kwalify::Util::HashLike
    
    def setup config ={}
      # TODO this needs to take into account recursion, to setup composed objects too
      config.each_pair {|k, v| self[k] = v}
    end
  end
end