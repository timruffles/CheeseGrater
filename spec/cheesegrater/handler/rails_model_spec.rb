root = File.dirname(__FILE__)
require root + '/../spec_helper'

# require lib yo!
include CheeseGrater

describe CheeseGrater::Handler::RailsModel do
  
  before :each do    
    @organiser =  Vo.new  :related_to => [],
                          :fields => {:name => 'blah',:title => 'xyz'},
                          :name => 'Organiser',
                          :handler => 'a',
                          :item_path => 'x'
                          
    @event =      Vo.new  :related_to => [@organiser],
                          :fields => {:start_date => Time.now,:title => 'xyz'},
                          :name => 'Event',
                          :handler => 'a',
                          :item_path => 'x'    
  end  

  context "passed a vo" do
    it "should save the vo using the Rails model specified by the Vo's name" do
      
    end
    
    context "with a related_to field" do
      it "should save the vo as a related field on the Vo specified in the related_to field" do
        
      end
    end
    
  end
  
  
end