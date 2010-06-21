module CheeseGrater
  module Request
    class Http < Base
    
      include Net
  
      @@supported_methods = ['get']

      def initialize config
        super(config)
        @method = config[:method] || @method
        raise InvalidOrMissingRequestMethod.new("Didn't recognise method '#{@method}'") unless @@supported_methods.include? @method
      end
  
      def run &block
        load(endpoint, &block)
      end
  
      def load endpoint
         open(endpoint) do |response|
           yield response.read
         end
      end
  
      def make_request uri
    
        path = uri.path != '' ? uri.path : '/'
        query = uri.query ? "?#{uri.query}" : ''
        request = path + query
    
      end
  
      define_exception :InvalidOrMissingRequestMethod
  
    end
  end
end