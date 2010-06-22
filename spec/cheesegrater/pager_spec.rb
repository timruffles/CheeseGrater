root = File.dirname(__FILE__) 
require root + '/spec_helper'

describe CheeseGrater::Pager do
  
  context "only given a next page url" do
    it "should be able to yield requests until no url is given"
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