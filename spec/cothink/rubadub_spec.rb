require File.dirname(__FILE__) + '/spec_helper'

class MixedInRubADub
  
  include RubADub

  cleaners :single_cleaner => [
    :strip
  ], :cleaner_in_class => [
    :instance_method_of_mixed_in_class,
  ], :exclude_value_key => [
    {:exclude => :value, :actions => [:strip]}
  ]
  
end

describe RubADub do
  
  before :each do
    @target = MixedInRubADub.new
  end
  
  it "should run cleaners that exist on the value" do
    value = mock(String)
    value.should_receive(:strip)
    @target.clean :single_cleaner, {:value => value}
  end
  
  it "should run cleaners that exist in the mixed in class" do
    @target.should_receive(:instance_method_of_mixed_in_class)
    @target.clean :cleaner_in_class, {:value => 'blah'}
  end
  
  it "should not run cleaners when the field is in the exclude hash" do
    value = mock(String)
    value.should_not_receive(:strip)
    not_excluded = mock(String)
    not_excluded.should_receive(:strip)
    @target.clean :exclude_value_key, {:value => value, :not_excluded => not_excluded}
  end
  
  
end


