require File.dirname(__FILE__) + '/eventscraper/event_vo'
require File.dirname(__FILE__) + '/eventscraper/scraper'
require File.dirname(__FILE__) + '/eventscraper/api_scraper'
require File.dirname(__FILE__) + '/eventscraper/url_scraper'
require File.dirname(__FILE__) + '/eventscraper/scraper_runner'
require File.dirname(__FILE__) + '/eventscraper/event_saver'
require File.dirname(__FILE__) + '/eventscraper/querystring_api_scraper'

scrapers_lib_dir = File.dirname(__FILE__) + '/eventscraper/scrapers'
Dir["#{scrapers_lib_dir}/*.rb"].each { |f| load(f) }
