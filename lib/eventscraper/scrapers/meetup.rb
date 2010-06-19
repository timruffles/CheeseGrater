class Meetup < ApiScraper
  def initialize(config)
    @topics = config['topics']
    @locations = config['locations']
    @key = config['key']
  end
  def scrape
    (@location_pairs ||= create_location_pairs).each do |pair|
      yield(MeetupTopicLocation.new(@key,pair[0],pair[1]))
    end
  end
  def create_location_pairs
    @topics.inject([]) do |list,topic|
      @locations.inject(list) do |list,location|
        list.push([topic,location])
      end
    end
  end
  def request(type,key,params)
    stringf(self.Enpointpoint,type,key,params)
  end
end
# at the moment, just london anyway
class MeetupTopicLocation < Scraper
  Source = 'meetup.com'
  require 'net/http'
  include Net
  Endpoint = 'http://api.meetup.com/2/%1$s.json/?key=%2$s&%3$s'
  def initialize(key,topic,location)
    @key = key
    @topic = topic
    @location = location
  end
  def scrape(&block)
    parse(make_request,&block)
  end
  def parse(request,&yield_proc)
    JSON.load(request)['results'].each do |event|
      v = event['venue'] ||= false
      address = v ? [v['name'],v['address_1'],v['address_2'],v['city']].join("\n") : Unknown
      yield_proc.call(EventVo.new(event['name'], 
                                  event['description'], 
                                  Time.at(event['time'].to_s.gsub!(/0+$/,'').to_i), 
                                  address,
                                  event['event_url'], 
                                  Source,
                                  event['group']['name']))
    end
  end
  def make_request
    HTTP.get(URI.parse(create_request_url('events',@key,{'topic' => @topic, 'country'=>@location[0],'city' => @location[1]})))
  end
  def create_request_url(type,key,params)
    sprintf(Endpoint,type,key,hash_to_query_s(params))
  end
end