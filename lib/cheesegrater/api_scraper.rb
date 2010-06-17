#require File.dirname(__FILE__) + '/scraper'
#require 'json/pure'

# creates all Requests required by an API setup
class ApiScraper
  
  @queue = :events
  
  def initialize(config)
    config = keys_to_symbols(config)
    @config = config
  end
  
  def scrape
    make_requests.each do |response|
      yield response
    end
  end
  
  def make_requests 
    
    fields_for_requests = []
    
    # prepare all fields, and generated diff hashes for all per request fields, adding to que of requests
    @request.fields.each_pair do |field, value|
      if value.respond_to? :[]
        case value[:type]
          when :one_per_request
            fields_for_requests += value.map {|val| {field => val} }
            @request.fields.delete(field)
          when :csv
           @request.fields[field] = value.join(',') 
        end
      end
    end
    
     # initial request which has transformed fields (eg csvs from [] to ,,), but is the same as req.fields
    fields_for_requests << {}
    
    # all additiional requests required
    fields_for_requests.map do |field_hash| 
      for_req = @config.dup
      for_req[:fields] = fields.merge(field_hash)
      ApiLevel2.new(for_req)
    end
  end
  
  # helper class to normalize config from yaml
  def keys_to_symbols(hash)
    class << hash
      def keys_to_symbols recursive = true
        inject({}).each_pair do | hash, (key,val)|
          if recursive AND val.class.equal? Hash 
            val = val.keys_to_symbols
          end
          hash[(key.to_sym rescue key) || key] = val
          hash
        end
      end
    end
    hash.keys_to_symbols
  end
  
end


# Runs an API scrape based on jsonpath info from a config hash, yielding Events and Additional scrapers
class ApiScraperL2
  
  @queue = :events
  
  def initialize config
    
  end
  def scrape &result_block
    jsonpath(@dataset,@response.item_graph) do |item|
      item_query(item, @response.fields) do |result|
        result_block.call result
      end
    end
  end
  
  def item_query item, fields
      model_hash = fields.inject({}) do |hash, graph|
        if is_related_scrape_request?(graph)
          yield related_scrape(item,graph)
        else
          hash[field.to_sym] = jsonpath(item,graph)
        end
      end
      yield @config[:model].new model_hash
  end
   
   def setup_pager!(config)
     Pager.new(config.delete(:pager))
   end

   # queries an item with jsonpath
   def jsonpath item, jsonpath
     JSONPath.lookup item, jsonpath
   end
end