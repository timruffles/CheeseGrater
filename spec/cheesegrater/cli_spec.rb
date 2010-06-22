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
    /Hi/.should(match(@output))
  end

  it "should warn when config file is not provided" do
    @cli.run []
    /No config file specified/.should match @output
  end
  
  it "should warn when config file cannot be opened" do
    @cli.run ['not there']
    /No such file or directory/.should match @output
  end

  it "should accept and load a config file" do
    args = (File.dirname(__FILE__) + '/fixtures/cli/config.yml').split(' ')

    @cli.run args

    /Loaded config.yml/.should match @output
  end
  
  it "should warn when it can't find any config files" do
    args = 'nothere.yml'.split(' ')
    @cli.run args
  end

end