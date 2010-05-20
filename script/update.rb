# What does this file do?

require 'FeedMapping.rb'
require 'Scraper.rb'

# load current events
events = event.fetch_all
event_mng = EventManager.new(events)

# get our urls
feed_list = gdoc_mng.load.as_feeds
feed_list.each do |feed|
  extractor_factor.get_factory(feed.type, feed.url).extract { |event| event_mng.event_found(event) }
end

