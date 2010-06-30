require "resque"
require "yaml"
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "thebusinessdiary_development",
  :username => "root",
  :password => ""
)

# freaks out loading acts as taggable on
#models_dir = File.dirname(__FILE__) + '/../../appq/app/models'
#load("#{models_dir}/event.rb")
#load("#{models_dir}/organisation.rb")

class Event < ActiveRecord::Base
  belongs_to :organisation
end

class Organisation < ActiveRecord::Base
  has_many :events
end

module CheeseGrater
  module Handler
    class RailsModel
      @queue = :save
      attr_accessor :vo
      
      def run         
        model = const_get(Vo.name).build Vo.fields
      end
      
      def self.perform(vo)
        vo = YAML::load(vo)
        e = Event.new(vo.fields)
        puts e.to_yaml
        puts ""
      end
    end
  end
end