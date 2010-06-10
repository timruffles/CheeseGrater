module Cothink
  module CoreExtension
    module Hash
      def keys_to_symbols recursive = true
        inject({}).each_pair do | hash (key,val)|
          if recursive && val.class.equal? Hash 
            val = val.keys_to_symbols
          end
          hash[(key.to_sym rescue key) || key] = val
          hash
        end
      end
    end
  end
end
      
      