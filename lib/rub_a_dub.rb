module RubADub
  
  def self.included into
    
    into.class_eval do
      
      @rubadub_setups = {}
      
      class << self
        def cleaners hash
          hash.each_pair do |key, filters|
            @rubadub_setups[key] = filters
          end
        end
        attr_accessor :rubadub_setups
      end
      
      def apply_cleaner method, value
        if respond_to? method
          self.send method, value
        elsif value.respond_to? method
          value.send method
        else
          raise "Neither the value nor #{self.class} with RubADub mixed in implemented method #{method}"
        end
      end
      
      def clean index, hash
        raise "RubADub clean called with undefined cleaner #{index}" unless setup = self.class.rubadub_setups[index]
        
        hash.each_pair do |key, value|
            setup.each do |cleaner|
              value = case cleaner
                        when Symbol
                          apply_cleaner(cleaner, value)
                        when Hash
                          if exclude = cleaner[:exclude]
                            # run all cleaners if key not in exclude array, or unaltered value if it is
                            excludes = [*exclude]
                            excludes.include?(key) ? value : cleaner[:actions].inject(value) do |value, action|
                              apply_cleaner(action, value)
                            end
                          else
                            raise "Unimplemented cleaning setup #{cleaner.inspect}"
                          end
                      end
            end
            hash[key] = value
        end
      end
      
      
    end
    
  end
  
end