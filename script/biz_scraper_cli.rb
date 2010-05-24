require 'yaml'
require 'csv'
FILEDIR = File.dirname(__FILE__) + '/'
require "#{FILEDIR}../lib/eventscraper"

output_file = "#{FILEDIR}../output/output.csv"

s = BusinessLink.new("#{FILEDIR}../spec/eventscraper/scrapers/fixtures/business_link.html")

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

for_csv = []
events.select { |e| e.respond_to? :title}.each do |event|
  order = [:title, :description, :date, :location, :organiser, :link, :source]
  for_csv << order.collect do |data|
    event.send(data)
  end
end
CSV.open("#{FILEDIR}../output/output.csv", "w") do |csv|
  for_csv.each do |line|
    csv << line
  end 
end