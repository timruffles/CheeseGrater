require 'yaml'
ROOT = '/Users/timruffles/Development/Cothink/spikes/EventsScraper/'
require "#{ROOT}lib/eventscraper"

s = BusinessLink.new("#{ROOT}spec/eventscraper/scrapers/fixtures/business_link.html")

l2 = []
s.scrape do |yielded|
  l2 << yielded
end

events = []
l2.each do |l2|
  l2.scrape do |yielded|
    events << yielded
  end
end

#puts events.select { |e| e.respond_to? :title}.first
events.select { |e| e.respond_to? :title}.each do |e|
  es = EventSaver.new
  es.perform(Marshal.dump(e))
end


