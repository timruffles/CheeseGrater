module Cothink
  module self::Configable
    def configure(setup)
      setup.each_pair do |key,val|
        if self.respond_to? key + '='
          self.send(key + '=', val)
        else
          instance_variable_set('@' + key, val)
        end
      end
    end
  end
end