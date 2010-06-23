require File.dirname(__FILE__) + '/spec_helper'

describe CheeseGrater::Runner do
  
  it "should create a specified runner from a lower case reepresentation of the class name" do
    
    module CheeseGrater
      module Runner
        class Test
        end
      end
    end
    
    CheeseGrater::Runner::Test === CheeseGrater::Runner.create('test')
    
  end
  
end