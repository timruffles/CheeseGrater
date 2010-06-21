module CheeseGrater
  module Request
    class Base

      def initialize config
        {:fields => false, :endpoint => true}.each_pair do |instance_var, required|
          raise MissingRequestField.new("Missing required setup #{instance_var.to_s}") if required && config[instance_var] == nil
          send("#{instance_var.to_s}=".to_sym, config[instance_var])
        end

        @config = config
      end
      
      def run
        raise "Run needs to be implemented by subclass"
      end

      attr_accessor :fields, :endpoint

    end
  end
end