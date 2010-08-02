require File.dirname(__FILE__) + '/spec_helper'

include Log4r

describe CheeseGrater::Cli do


  before :each do

    @cli = CheeseGrater::Cli.new
    @output = ''

    strio = StringIO.new @output, 'w+'
    test_out = IOOutputter.new 'test_log', strio
    
    test_log = Logger[CheeseGrater::Cli::CLI_LOGGER_NAME] 
    test_log.outputters = test_out

    @cli.send(:instance_variable_set, :@logger, test_log)

  end

  it "should warn when config file is not provided" do
    @cli.run []
    /No config file specified/.should match @output
  end
  
  it "should warn when config file cannot be opened" do
    @cli.run ['not there']
    /No such file or directory/.should match @output
  end
  
  it "should mixin the outputters option into the config" do
    
    finished_config = nil
    
    loader = mock('Loader')
    CheeseGrater::Loader.should_receive(:new).and_return(loader)
    loader.should_receive(:load) do |config|
      finished_config = config
    end
    
    args = [(File.dirname(__FILE__) + '/fixtures/cli/config.yml')]
    @cli.run ['-o','stdout'] + args
    @cli.instance_variable_get(:@options).outputters.should == ['stdout']
    
    finished_config['log4r_config']['loggers'][0]['outputters'].should == ['stdout']
    
  end
  
  it "should accept and load a config file" do
    args = [(File.dirname(__FILE__) + '/fixtures/cli/config.yml')]

    @cli.run args

    /Loaded.*config.yml/.should match @output
  end
  
  it "should warn when it can't find any config files" do
    args = 'nothere.yml'.split(' ')
    @cli.run args
  end

end