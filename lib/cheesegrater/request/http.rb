require 'net/http'
require 'open-uri'
require 'cgi'

module CheeseGrater
  module Request
    class Http < Base
      
      include Net, Logging
  
      @@supported_methods = ['get']

      def initialize config
        super(config)
        @method = config[:method] || 'get'
        raise InvalidOrMissingRequestMethod.new("Didn't recognise method '#{@method}'") unless @@supported_methods.include? @method
      end
  
      def run
        load(endpoint)
      end
      
      def load endpoint
         raw_response = nil
         open(endpoint) do |response|
           logger.info "#{self.class} received a response #{response.length} characters long from #{endpoint}"
           raw_response = response.read
         end
         raw_response
      rescue StandardError => e
        raise e
      end
  
      define_exception :InvalidOrMissingRequestMethod
  
    end
  end
end