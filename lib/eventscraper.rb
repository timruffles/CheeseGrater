require File.dirname(__FILE__) + '/eventscraper/event_vo'
require File.dirname(__FILE__) + '/eventscraper/scraper'
require File.dirname(__FILE__) + '/eventscraper/api_scraper'
require File.dirname(__FILE__) + '/eventscraper/url_scraper'
require File.dirname(__FILE__) + '/eventscraper/scraper_runner'
require File.dirname(__FILE__) + '/eventscraper/event_saver'
require File.dirname(__FILE__) + '/eventscraper/querystring_api_scraper'

sdir = File.dirname(__FILE__) + '/eventscraper/scrapers'
Dir.new(sdir).select {|f| f !~ /^\.+/ }.each do |scraper|
  require sdir + '/' + scraper.gsub!('.rb','')
end