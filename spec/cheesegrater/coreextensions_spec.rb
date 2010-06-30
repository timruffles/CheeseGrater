#require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../../lib/cheesegrater/coreextensions'

describe "Core extensions defined by CheeseGrater" do
  
  context "Module" do
    
    context "define_exception" do
      
       module Tester
          define_exception :TestException, 'The default message'
          define_exception :TestRuntimeException, 'The default message', RuntimeError
       end
    
      it "should allow the user to add an exception class to a module" do
          Tester.constants.include?('TestException').should == true
      end
      
      it "should allow the user to set the default message of that exception" do
        e                   = Tester::TestException.new
        e.to_s.should == 'The default message'
        e                   = Tester::TestException.new "A message"
        e.to_s.should == "A message"
      end
      
      it "should allow the user to set the type of that exception" do
        e                   = Tester::TestException.new
        (RuntimeError === e).should == true
      end
      
    end
  end
  
  context "String" do
  
    context "join_with" do
     it "should join two strings with a joiner without creating duplicate joining characters" do
       urls                 = {
         :with_trail        => 'http://blah.com/',
         :with_double_trail => 'http://blah.com/',
         :without_trail     => 'http://blah.com'
       }
       to_join              = {
         :with_trail        => '/html.html',
         :without_trail     => 'html.html'
       }
       
       urls.values.each do |url|
         to_join.values.each do |args|
           url.join_with('/',args).should == 'http://blah.com/html.html'
         end
       end
       
     end
     
      it "should not add a joiner when one string is empty" do

        'http://blah.com/'.join_with('/','').should == 'http://blah.com/'
        'http://blah.com'.join_with('/','').should == 'http://blah.com'
      end
      
      it "unless requested" do

        'http://blah.com/'.join_with('/','',true).should == 'http://blah.com/'
        'http://blah.com'.join_with('/','',true).should == 'http://blah.com/'
      end
    end
  end
  
end
