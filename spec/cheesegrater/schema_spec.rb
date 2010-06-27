root =  File.dirname(__FILE__) 
require root + '/spec_helper'
require 'kwalify'

describe 'kwal loading process' do
  
  it "should create classes with binding" do
    
      # metavalidator = Kwalify::MetaValidator.instance
      # 
      # parser = Kwalify::Yaml::Parser.new(metavalidator)
      # errors = parser.parse(schema)
      # puts errors.to_yaml
      # for e in errors
      #   puts "#{e.linenum}:#{e.column} [#{e.path}] #{e.message}"
      # end if errors && !errors.empty?
  
      test_validator = Kwalify::Validator.new(Kwalify::Yaml.load(schema))
  
      parser = Kwalify::Yaml::Parser.new(test_validator)
      parser.data_binding = true    # enable data binding
  
      errors = parser.errors()
      if errors && !errors.empty?
        for e in errors
          puts "#{e.linenum}:#{e.column} [#{e.path}] #{e.message}"
        end
      end
  
      p config = parser.parse_file("#{root}/fixtures/kwalify.yml")
      p config[0]["scrapers"][0].class
  end
end