require 'net/http'
require 'open-uri'
require 'cgi'

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
      rescue StandardError => e
        raise e.class.new "Could not load endpoint #{endpoint}, got #{e}"
      end
  
      define_exception :InvalidOrMissingRequestMethod
  
    end
  end
end