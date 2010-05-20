require File.dirname(__FILE__) + '/scraper'

class UrlScraper < Scraper
  def initialize(url)
    @url = url
  end
  attr_accessor :url
end