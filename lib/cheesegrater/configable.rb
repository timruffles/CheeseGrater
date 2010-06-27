module CheeseGrater
  module Configable
    
    include Kwalify::Util::HashLike
    
    def setup config ={}
      config.each_pair {|k, v| self[k] = v}
    end
  end
end