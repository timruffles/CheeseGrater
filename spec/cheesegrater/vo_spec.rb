root = File.dirname(__FILE__) 
require root + '/spec_helper'

include CheeseGrater

describe Vo do
  
  fixtures = YAML.load_file(root + '/fixtures/vo.yml').keys_to_symbols
  
  it "creates a list of vos from a config hash" do
    
    Vo.should_receive(:new).and_return({})
    
    vos = Vo.create_all(fixtures[:one_vo])
    vos.length.should == 1
    
  end
  
  context "setting up from config hash, it should:" do
    
    before :each do
      vos = Vo.create_all(fixtures[:one_vo])
      @test_vo = vos[0]
    end

    it "reads and expose its item_path" do
      @test_vo.item_path.should == '//event'
    end
    it "reads a fields hash" do
       expected = {:title => './title',
                   :description => './description',
                   :location => ['./venue/name','./venue/address','./venue/address_2','./venue/city','./venue/postal_code'],
                   :start_date => './start_date',
                   :url => './url',
                   :people => 'Unknown',
                   :notes => 'Unknown'}
       @test_vo.fields.should == expected
    end
    it "reads its related hash" do
      # todo - the component needs to interpret the symbol :"EventBrite::Organiser::Organiser"
      @test_vo.related_to[:"EventBrite::Organiser::Organiser"][:fields][:id].should == %w[./organiser/id]
    end
    it "reads its name" do
      @test_vo.name.should == :Event # todo: this is a symbol, and will be used by handlers to indentify
    end
    it "reads its handler's name" do
      @test_vo.handler.should == 'RailsModel'
    end
    
  end
  
end