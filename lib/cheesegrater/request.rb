#require 'active_support' constantize doesn't find names right now
module CheeseGrater
  module Request
    
    Csv = 'csv'
    OnePerRequest = 'one_per_request'
    
    class << self
      
      # create a scraper with a prepared config hash (all fields expanded/formatted etc)
      def create config
        clazz = (if config[:format] == 'querystring'
            Querystring
        end)
        
        return clazz.new(config) if clazz
        raise "Unrecognised Request type #{type}"
      end
      
      # create all requsts required, formatting fields
      def create_requests config

         field_overrides = []
         
         fields = prepare_fields_and_override_hashes(config[:fields]) do |overridden_fields_for_request|
           field_overrides << overridden_fields_for_request
         end
         
          # initial request which has formatted fields (eg csvs from [] to ,,), but otherwise is the same as config[:fields]
         field_overrides << {}

         # return with all additiional requests required
         field_overrides.map do |override_hash| 
           self.create(config.merge({:fields => fields.deep_merge(override_hash)}))
         end
       end
       
       # prepare all fields, and generated diff hashes for all per request fields, adding to que of requests
       def prepare_fields_and_override_hashes fields
         fields = fields.dup
         fields.each_pair do |field, setup|
            if setup.respond_to? :[]
              value = setup[:value]
              case setup[:type]
                when OnePerRequest
                  # use first one for initial request, and rest for additional, yielding n - 1 new requests
                  fields[field] = value.shift
                  (value.map {|val| {field => val} }).each do |overrides|
                    yield overrides
                  end
                when Csv
                  fields[field] = value.join(',') 
              end
            end
          end
       end
    end
    
    class Base
      def initialize config
        {:fields => false, :endpoint => true}.each_pair do |instance_var, required|
          raise "Missing required setup #{instance_var.to_s}" if required && config[instance_var] == nil
          send("#{instance_var.to_s}=".to_sym, config[instance_var])
        end
      end
      
      attr_accessor :fields, :endpoint
    end
    
    class Http < Base
      
    end
    
    class Querystring < Http
      
      
    end
    
  end
  
  attr_reader :fields
end