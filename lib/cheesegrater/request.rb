#require 'active_support' constantize doesn't find names right now
module CheeseGrater
  module Request

    Csv = 'csv'
    OnePerRequest = 'one_per_request'

    class << self

      # create a scraper with a prepared config hash (all fields expanded/formatted etc)
      def create config
        clazz = if config[:format] == 'querystring'
          Querystring
        end

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

    define_exception :MultiplePerRequestFieldError
    define_exception :MissingRequestField
    define_exception :InvalidRequestFormat

    attr_reader :fields

  end
end