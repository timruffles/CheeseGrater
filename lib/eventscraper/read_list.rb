# fetch urls, and append appropriate scrapers to the job que
require 'yaml'

feed_list = gdoc_mng.load.as_feeds
scraper_factory = ScraperFactory.new
feed_list.each do |feed|
  config = YAML::load_file('config.yaml')
  scraper = scraper_factory.get_scraper_class(feed.type, feed.url, config)
  Resque.enqueue (ScraperRunner,Marshal.dump(scraper))
end