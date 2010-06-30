require File.dirname(__FILE__) + '/../../spec_helper'

include CheeseGrater::Scraper::Helper

describe Base do
  
  before :each do
    @base = Base.new
  end
  
  it "should match lots of badly formatted telephone numbers" do
    
    test = ['0  7766373556', '0776 378373', '01225311662', '+44(0)1225 311662', '(1273)-2522 2665554', '020 7527 2709']


    (test.all? do |test|
      p test unless @base.optimistic_telephone_re =~ test
      @base.optimistic_telephone_re =~ test
    end).should == true
    
    
  end
  
  it "should match lots of badly formatted email addresses" do
    
    match = ['tim @ blah dot com', 'tim at blah.com', 'tim(at)blah.com', 'tim at blah dot com','tim (at) blah dot com''tim@blah.com','jean.paul@francious.fr.co','montague_pyke.one@py.cc', 'tim @ blah . com']
    dont_match = ['deep-blue at his house','great time at the park','how was wednesday @ jojo\'s?', 'shop at portsmouth. It is', 'verily at her. Lots more']


    match.each do |test|
      @base.optimistic_email_re.should match test
    end
    
    dont_match.each do |test|
      @base.optimistic_email_re.should_not match(test)
    end
    
    
    
  end
  
  it "should output found items with spaces between" do
    
    contains = ['0  7766373556', '0776 378373', '01225311662', '+44(0)1225 311662', '(1273)-2522 2665554', '020 7527 2709']
    test = '0  7766373556 and blah blah0776 378373 and blah blah01225311662 and blah blah+44(0)1225 311662 and blah blah(1273)-2522 2665554 and blah blah020 7527 2709'
    
    result = @base.optimistic_telephone(test)
    contains.each do |no|
      result.include?(no).should == true
    end
    
  end
  
  
  
end