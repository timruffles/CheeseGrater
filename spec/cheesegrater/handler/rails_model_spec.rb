root = File.dirname(__FILE__)
require root + '/../spec_helper'

describe CheeseGrater::Handler::RailsModel do
  
  context "passed a vo" do
    it "should save the vo using the Rails model specified by the Vo's name"
    
    context "with a related_to field" do
      it "should save the vo as a related field on the Vo specified in the related_to field"
    end
    
  end
  
  
end