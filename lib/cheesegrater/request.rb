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
        raise InvalidRequestFormat.new("Unrecognised Request format #{config[:format]}")
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
         one_per_request_count = 0
         
         fields.each_pair do |field, setup|
            if setup.respond_to? :[]
              value = setup[:value]
              case setup[:type]
                
                when OnePerRequest
                  
                  one_per_request_count += 1
                  raise MultiplePerRequestFieldError unless one_per_request_count == 1
                  
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
          raise MissingRequestField.new("Missing required setup #{instance_var.to_s}") if required && config[instance_var] == nil
          send("#{instance_var.to_s}=".to_sym, config[instance_var])
        end
        
        @config = config
      end
      
      attr_accessor :fields, :endpoint
    end
    
    class Http < Base
      
      include Net
      
      @@supported_methods = ['get']

      def initialize config
        super(config)
        @method = config[:method] || @method
        raise InvalidOrMissingRequestMethod.new("Didn't recognise method '#{@method}'") unless @@supported_methods.include? @method
      end
      
      def run &block
        yield load(endpoint, &block)
      end
      
      def load endpoint
        
         uri = URI.parse(endpoint)
         request = make_request uri
         
         response = {}
         previous_locations = []
         requests = 0
         
         while requests < 10
           
           requests += 1
           
           http = HTTP.new(uri.host, uri.port) 
           response = http.send(@method, request)
           
           if response['location']
             uri = URI.parse(response['location'])
             request = make_request(uri)
           else
             yield response.body
             break
           end
           
         end
         
      end
      
      def make_request uri
        
        path = uri.path != '' ? uri.path : '/'
        query = uri.query ? "?#{uri.query}" : ''
        request = path + query
        
      end
      
      define_exception :InvalidOrMissingRequestMethod
      
    end
    
    class Querystring < Http
      
      def initialize config
        @method = 'get'
        super config
      end
      
      def endpoint
        @endpoint + hash_to_query_s(fields)
      end
      
      # query string format for a hash, with trailing ?
      def hash_to_query_s(params_hash)
        '?' + (params_hash.to_a.collect do |k_v|
          sk, sv = CGI::escape(k_v[0].to_s), CGI::escape(k_v[1].to_s)
          "#{sk}=#{sv}"
        end).join('&')
      end
     
    end
    
    define_exception :MultiplePerRequestFieldError
    define_exception :MissingRequestField
    define_exception :InvalidRequestFormat
    
  end
  
  attr_reader :fields
end