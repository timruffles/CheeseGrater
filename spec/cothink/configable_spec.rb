require File.dirname(__FILE__) + '/spec_helper'

describe Cothink::Configable do
  context 'when mixed into a class' do
    
    class Subject 
      include Cothink::Configable
      def initialize(config)
        @foo
        @bar
        configure(config)
      end
      attr_accessor :foo, :bar
    end
    
    it 'should allow that class to initialize its instance variables by a hash passed in' do
      
      test_config = {"foo" => "v1", "bar" => 'v2'}
      sut = Subject.new(test_config)
      
      sut.foo.should == test_config['foo']
      sut.bar.should == test_config['bar']
    end
  end
end