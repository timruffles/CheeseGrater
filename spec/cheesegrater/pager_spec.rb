root = File.dirname(__FILE__) 
require root + '/spec_helper'

describe CheeseGrater::Pager do
  
  context "given an empty setup" do
    it "should yield a null page fields" do
      
      pager = CheeseGrater::Pager.create({})
      yielded = []
      
      pager.page do |fields|
        
        fields.should == {}
        
      end
      
    end
  end
  
  context "only given a next page url" do
    it "should be able to yield requests until no url is given" do
      
      url_path = '//blah'
      pager = CheeseGrater::Pager.create({:request => 
                                            {:next_page_url_path => url_path}
                                        })
                                        
      response = mock('Response')
      response.should_receive(:value).with(url_path).and_return('http://example')
      
      yielded = []
      pager.page do |fields|
        
        fields.should == {:next_page_url_path=>'http://example'}
        yielded << fields 
        
        response.should_receive(:value).with(url_path).and_return('')
        response
      end
      yielded.length.should == 1
    end
  end
  
  context "given a page field" do
    context "only" do
      it "should be page to yield requests until the request fails"
    end
    context "with a last page" do
      it "should yield all possible pages immediately"
    end
  end
  
  context "given onluy a per page, and total items" do
    it "should immediately yield all possible requests"
  end
  
end