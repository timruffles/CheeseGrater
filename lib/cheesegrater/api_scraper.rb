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
      yield @config[:model].new(model_hash)
  end
   
   def setup_pager!(config)
     Pager.new(config.delete(:pager))
   end

   # queries an item with jsonpath
   def jsonpath item, jsonpath
     JSONPath.lookup item, jsonpath
   end
end