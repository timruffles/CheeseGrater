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
    request.stub(:fields).and_return({})
    request.stub(:setup)

    responses = []
    @scraper.send(:make_requests, [request], CheeseGrater::Pager.new) do |raw_response|
      responses << raw_response
    end
    responses.length.should == 1
    responses[0].should == response_msg
  end
  
  context "fields hash" do
    
    it "should recognise and react when a field query requires a method call" do
      
      two_context = mock('Request')
      endpoint = 'http://blah.com'
      two_context.should_receive(:endpoint).and_return(endpoint)
      
      @scraper.stub(:one).and_return(two_context)
      field = [:method, :one, :endpoint]
      
      @scraper.send(:perform_field_query, field, {}, {})
      
    end
    
    it "should recognise and react when a field query requires a literal" do
      
      field = [:literal, 'hello']
      @scraper.send(:perform_field_query, field, {}, {}).should == 'hello'
      
    end
    
    it "should keep running 'try_each' clauses when nothing is returned" do
      
      query_context = {}
      
      response = mock('Response')
      response.should_receive(:scalar_query).with(:fail,{}).and_return(nil)
      response.should_receive(:scalar_query).with(:succeed,{}).and_return(:some_data)
      
      fields_hash = YAML.load <<-YAML
        :field_a:
          :try_each:
            - :fail
            - :succeed
      YAML
      
      results = @scraper.send :perform_data_requests, response, fields_hash, query_context
      
      results[:field_a].should == :some_data
      
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