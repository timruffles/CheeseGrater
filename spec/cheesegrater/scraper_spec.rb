root = File.dirname(__FILE__) 
require root + '/spec_helper'

include CheeseGrater

describe CheeseGrater::Scraper do
  
  before :each do
    @scraper = CheeseGrater::Scraper.new({})
    @fixtures = YAML.load_file(root + '/fixtures/scraper.yml').keys_to_symbols
    @xpath_response = Response::XpathHtml.new
    
    @vos_for_fixture_one = [Vo.new({:fields => 
                      {:location_code => "./@value"},
                  :related_to => {},
                  :item_path => "//*[@id='location']/*[@value!='-999']"})]
    
  end
  
  it "should be dumpable" do
    s = CheeseGrater::Scraper.new({})
    Marshal.dump(s)
  end
  
  it "should run requests and yield the raw responses" do
    
    response_msg = 'Response read!'
    
    request = mock('Request')
    request.should_receive(:run).and_return(response_msg)
    request.stub(:setup)

    responses = []
    @scraper.send(:make_requests, [request], CheeseGrater::Pager.new) do |raw_response|
      responses << raw_response
    end
    responses.length.should == 1
    responses[0].should == response_msg
  end
  
  context "integration" do
    
    it "should yield related scrapers" do
      
      @xpath_response.raw = @fixtures[:scrapers]
      
      related_scrapers = {
                      'ScraperOne' => Scraper.new(:requests         => [Request::Base.new({:fields=>{:app_key => 'blah', :date => 'x'},:endpoint=>'x'})],
                                                  :response         => Response::XpathHtml.new,
                                                  :vos              => Vo.new({}),
                                                  :pager            => Pager.new,
                                                  :is_root          => true,
                                                  :related_scrapers => {},
                                                  :scrapers         => {})
                    }
      scrapers = {
        'ScraperOne' => {:item_path => "//*[@id='eventDate']//*[@value!=99]", :fields => {:date=>"./@value"}}
      }
      
      results = []
      @scraper.send(:read_response, [], @xpath_response, related_scrapers, scrapers) do |scraped|
        results << scraped
      end
      
      (total_of_vals = results.inject(0) do |acc, scraper|
        acc += scraper.requests.inject(0) {|acc, r| acc += r.fields[:date].to_i}
      end).should == 153
      
      results.select do |scraper|
        scraper.requests[0].fields[:app_key].should == 'blah'
      end
      results.length.should == 18
      
    end
  
    it "should yield vos" do
      
      @xpath_response.raw = @fixtures[:one]
      
      results = []
      @scraper.send(:read_response, @vos_for_fixture_one, @xpath_response) do |scraped|
        results << scraped
      end
      
      (total_of_location_codes = results.inject(0) do |acc, vo|
        acc += vo.fields[:location_code].to_i
      end).should == 110
      
    end
    
    context "given a vo with a list of related vos" do
    
      context "when the vo data is present on the same page" do
        
        def run yaml
          @xpath_response.raw = @fixtures[:related_vos_on_page]
          
          vos = Vo.create_all YAML.load(yaml
          ).keys_to_symbols
          
          results = []
          @scraper.send(:read_response, vos, @xpath_response) do |scraped|
            results << scraped
          end
          
          results
        end
        
        it "should only yield the vo with related vos containing requested data, when the paths are relative to the original VO" do
          
          results = run <<-YAML
          Event:
              item_path: id('rightContent')
              fields:
                  title: //h1[1]
              related_to:
                  Organiser:
                      item_path: id('rightContent')
                      fields:
                          name: ./p/strong[contains(.,'Organised By')]/..
          YAML
          
          results.length.should == 1
          vo = results.shift
          vo.related_to.length.should == 1
          /4Networking/.should match(vo.related_to[:Organiser].fields[:name])
        end
        
        it "should only yield the vo with related vos containing requested data, when the paths are not relativ to the original VO" do
          
          results = run <<-YAML
          Event:
              item_path: id('rightContent')
              fields:
                  title: //h1[1]
              related_to:
                  Organiser:
                      fields:
                          name: id('rightContent')/p/strong[contains(.,'Organised By')]/..
          YAML
          
          results.length.should == 1
          vo = results.shift
          vo.related_to.length.should == 1
          /4Networking/.should match(vo.related_to[:Organiser].fields[:name])
          
        end
        
        
      end
      
      context "when the vo data is on another page" do
        
        it "should yield each of the related vo scrapers with the original vo's UUID in their relations'" do
          
          @xpath_response.raw = @fixtures[:related_vos_on_page]
          
          vos = Vo.create_all YAML.load(<<-YAML
            Event:
                item_path: id('rightContent')
                fields:
                    title: //h1[1]
                related_to:
                    Scraper::Organiser:
                        item_path: id('rightContent')
                        fields:
                            name: id('rightContent')/p/strong[contains(.,'Organised By')]/..
          YAML
          ).keys_to_symbols
          
          related_scraper = Scraper.new({
            :requests => [
              Request::Base.new({
                                  :fields => {},
                               })],

             :vos => {

               :Organiser => Vo.new({})

             }

          })
          
          results = []
          @scraper.send(:read_response, vos, @xpath_response, {:Scraper => related_scraper}) do |scraped|
            results << scraped
          end
          related_scraper, vo = results
          results.length.should == 2
          related_scraper.vos[:Organiser].related_to[:Event].should == vo.fields[:uuid]
        end
        
      end
      
    end
    
    context "when a helper class exists" do
      
      
      module CheeseGrater
        class Scraper
          module Helper
            class Test
              
              def included_method
                
              end
              
              def format_vo_fields name, fields
                fields
              end
              
            end
          end
        end
      end
      
      it "should instantiate that module on initialization" do
        
        scraper = Scraper.new({:name => 'Test'})
        (Scraper::Helper::Test === scraper.helper).should == true
        (scraper.helper.respond_to? :included_method).should == true
      end
      
      it "should apply the helper methods as hooks" do
        
        scraper = Scraper.new({:name => 'Test'})
        scraper.helper.should_receive(:format_vo_fields).exactly(5).times.and_return({})
        
        @xpath_response.raw = @fixtures[:one]
        scraper.send(:read_response, @vos_for_fixture_one, @xpath_response) do |scraped|
        end
        
      end
      
    end
    
  end
  
end