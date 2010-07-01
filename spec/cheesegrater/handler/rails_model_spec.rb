root = File.dirname(__FILE__)
require root + '/../spec_helper'

# require lib yo!
include CheeseGrater

describe CheeseGrater::Handler::RailsModel do
  
  before :each do    
    @org_vo =     Vo.new  :related_to => [],
                          :fields => {:name => 'blah',:title => 'xyz'},
                          :name => 'Organiser',
                          :handler => 'a',
                          :item_path => 'x'
                          
    @event_vo =   Vo.new  :related_to => {:Organisation => @org_vo},
                          :fields => {:start_date => Time.now,:title => 'xyz'},
                          :name => 'Event',
                          :handler => 'a',
                          :item_path => 'x'
                          
    @serialised_event = YAML::dump(@event_vo)
    
    @handler = Handler::RailsModel
  end  
  
  context "passed a yaml serialised vo" do
    it "should unserialise the object"

    it "should save an event into activerecord when passed without associations" do
      @mock_model = mock('Event')
      @mock_model.should_receive(:save)
      Handler::Event.should_receive(:new).and_return(@mock_model)
      
      @handler.perform(@serialised_event)      
    end
    
    
    it "should save a related vo with uuid"
    
    it "should save a related vo if it's passed as an object'"
    
  end

  # context "passed a vo" do
  # 
  #   it "should save the vo using the Rails model specified by the Vo's name" do      
  #   end
  #   
  #   context "with a related_to field" do
  #     it "should save the vo as a related field on the Vo specified in the related_to field" do
  #       
  #     end
  #   end
  #   
  # end
  
  
end