require File.dirname(__FILE__) + '/scraper'
require 'json/pure'

class ApiScraper
  def initialize(topics,locations)
    @topics = topics
    @locations = locations
  end
  attr_accessor :topics, :locations
end