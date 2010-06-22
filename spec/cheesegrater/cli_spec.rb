require File.dirname(__FILE__) + '/spec_helper'

include Log4r

describe CheeseGrater::Cli do
  
  
  before :each do
    
    @cli = CheeseGrater::Cli.new
    @output = ''
    
    strio = StringIO.new @output, 'w+'
    test_out = IOOutputter.new 'test_log', strio
    
    test_log = Logger.new 'test_logger' 
    test_log.outputters = test_out
    
    @cli.send(:instance_variable_set, :@logger, test_log)
    
  end
  
  it "should log output through a logger" do
    msg = 'Hi'
    @cli.instance_eval do 
      logger.info msg
    end
    /Hi/.should match @output
  end
  
  it "should accept a config file with " do
    ARGV = '../spec/fixtures/cli/config.yml'.split(' ')
    
    @cli.run 
    
    /Loaded config.yml/.should match @output
  end
  
  it "should warn when it can't find any config files" do
    ARGV = 'nothere.yml'.split(' ')
    @cli.run
  end
  
end