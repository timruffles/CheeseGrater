require File.dirname(__FILE__) + '/../../spec_helper'

include CheeseGrater::Scraper::Helper

describe Base do
  
  it "should match lots of badly formatted telephone numbers" do
    
    base = Base.new
    
    test = ['0  7766373556', '0776 378373', '01225311662', '+44(0)1225 311662', '(1273)-2522 2665554', '020 7527 2709'
    ]


    (test.all? do |test|
      p test unless base.optimistic_telephone_re =~ test
      base.optimistic_telephone_re =~ test
    end).should == true
    
    
  end
  
  it "should match lots of badly formatted email addresses" do
    
    base = Base.new
    
    match = ['tim @ blah dot com', 'tim at blah.com', 'tim(at)blah.com', 'tim at blah dot com','tim@blah.com','jean.paul@francious.fr.co','montague_pyke.one@py.cc']
    dont_match = ['at his house','great time at the park','how was wednesday @ jojo\'s?']


    match.each do |test|
      base.optimistic_email_re.should match test
    end
    
    dont_match.each do |test|
      base.optimistic_email_re.should_not match(test)
    end
    
    
    
  end
  
  
  
end