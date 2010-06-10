require File.dirname(__FILE__) + '/scraper'
require 'json/pure'


# Runs an API scrape based on jsonpath info from a config hash

class ApiScraper
  
  def initialize(config)
    config = keys_to_symbols(config)
    @jsonpath = config.delete(:request_type)
  end
  
  # * Generate all result sets, with all items query with field sets, yield hashes for results
  def scrape &result_block
    
    make_requests(@pager).each do |response|
      jsonpath(response,@response.item_graph) do |item|
        item_query(item, @response.fields) do |result|
          result_block.call result
        end
      end
    end
    
  end
  #
  def item_query item, fields
    
    yield fields.inject({}) do |hash, graph|
      if is_related_scrape_request?(graph)
        yield related_scrape(item,graph)
      else
        hash[field.to_sym] = jsonpath(item,graph)
      end
    end
    
  end
  
  def make_requests pager, &block
    
    per_request_fields = []
    
    ## prepare all fields, and separate out all per request fields
    @request.fields.each_pair do |field, value|
      if value.respond_to? :[]
        case value[:type]
          when :one_per_request
            per_request_fields += value.map {|value| {field => value} }
            @request.fields.delete(field)
          when :csv
           @request.fields[field] = value.join(',') 
        end
      end
    end
    
    # initial request
    
    # all additiional requests required
    per_request_fields.each do |field_hash| 
      make_request(fields.merge(field_hash),pager,&block)
    end
    
    
  end
  
  def make_request fields, pager
    
    yield url_query(@request.fields)
    
  end
  
  
  
  def setup_pager!(config)
    Pager.new(config.delete(:pager))
  end
  
  # queries an item with jsonpath
  def jsonpath item, jsonpath
    JSONPath.lookup item, jsonpath
  end
  
  # helper class to normalize config from yaml
  def keys_to_symbols(hash)
    class << hash
      def keys_to_symbols recursive = true
        inject({}).each_pair do | hash (key,val)|
          if recursive && val.class.equal? Hash 
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