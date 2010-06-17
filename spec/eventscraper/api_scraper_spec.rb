require File.dirname(__FILE__) + '/../../lib/eventscraper'

describe ApiScraper do  
  
  it "should turn a list of params into urls" do

    ApiScraper :querystring, { :topic => {:values=>['business','networking skills'],:type=>:one_per_request},
                               :country => {:values => %w[gb us fr], :type => :csv} }
    
  end
  
end