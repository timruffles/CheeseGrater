scraper_class = ARGV[0];

scraper = scraper_class.new

scraper.scrape ARGV[1] do |yielded|
  puts yielded
end