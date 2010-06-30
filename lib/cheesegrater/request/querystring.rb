module CheeseGrater
  module Request
    class Querystring < Http

      def initialize config
        @method = 'get'
        super config
      end

      def endpoint
        fields = @fields.dup
        no_key = (fields.delete(:no_key) || []).to_a
        "#{@endpoint}".join_with('/',no_key.join).join_with('?',hash_to_query_s(fields))
      end

      # query string format for a hash, with trailing ?
      def hash_to_query_s(params_hash)
        (params_hash.to_a.collect do |k_v|
          sk, sv = CGI::escape(k_v[0].to_s), CGI::escape(k_v[1].to_s)
          "#{sk}=#{sv}"
        end).join('&')
      end

    end
  end
end