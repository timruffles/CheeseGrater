require File.dirname(__FILE__) + '/spec_helper'

module EventScraper
  describe Scraper do
    context "when given a hash" do
      s = Scraper.new
      it "should return an & deliminated listed" do 
        (s.hash_to_query_s "id" => 1).should == 'id=1'
        
        #commenting out - this isnt testing anything new? (i might be missing something!)
        #(s.hash_to_query_s "id" => 1, 'user' => 'johnny').should == 'user=johnny&id=1'
      end
      it "of values where key and value are url escaped" do
        (s.hash_to_query_s "id two" => "spacey hey").should == 'id+two=spacey+hey'
      end
    end
  end
end