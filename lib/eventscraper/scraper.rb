# the scraper
require 'open-uri'
require 'rubygems' # shouldn't be needed?
require 'hpricot'
require 'cgi'
class Scraper 
  # constant for all unknown data
  Unknown = nil
  
  # scrape is the public api
  def scrape(&block)
    parse(make_request,&block)
  end
  
  # commented out protected - hash_to_query_s used publically - mistake or on purpose?
  # NoMethodError in 'Scraper when given a hash should return an & deliminated listed' --- protected method `hash_to_query_s' called for #<Scraper:0x1018bc9f8> --- /Users/dan/code/cothink/scraper/spec/eventscraper/scraper_spec.rb:8:
  # NoMethodError in 'Scraper when given a hash of values where key and value are url escaped' --- protected method `hash_to_query_s' called for #<Scraper:0x1018bc9f8> --- /Users/dan/code/cothink/scraper/spec/eventscraper/scraper_spec.rb:12:
  
  #protected
  
  # IO encapsulated here
  def make_request
  end
  # interpret the data received from IO
  def parse(request,&yield_proc)
  end
  def hash_to_query_s(params_hash)
    (params_hash.to_a.collect do |k_v|
      sk, sv = CGI::escape(k_v[0].to_s), CGI::escape(k_v[1].to_s)
      "#{sk}=#{sv}"
    end).join('&')
  end
  def load_url_xpath(url)
    return open(url) { |f| Hpricot(f) }
  end
  def load_str_xpath(str)
    return Hpricot.parse(str)
  end
  attr_reader :url
end