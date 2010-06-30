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
      
      # is this used?
      def run         
        model = const_get(Vo.name).build Vo.fields
      end
      
      # step through following, make sure works...
      
      def self.perform(vo)
        vo = YAML::load(vo)
        e = Event.new(vo.fields)
        puts e.to_yaml
        puts ""
         
      #   # grab the model that relates to the VO, and instantiate it
      #   model_class = const_get(vo.name)
      #   model = model_class.new( vo.fields )
      #   
      #   # the vo could have one of two things here, a hash of model names (eg Organiser) to UUIDs of
      #   # previously yielded Vos, or a hash of model names to Vos.
      #   vo.related_to.each_pair do |name, vo_or_uuid|
      #     
      #     related_model = const_get(name)
      #     
      #     # if it's a UUID, retrieve the model by that
      #     # if it's a VO, create the model using the VO's fields
      #     if vo_or_uuid.respond_to? :fields
      #       relation_model = related_model.new(vo_or_uuid.fields)
      #     else
      #       relation_model = related_model.find_by_uuid(vo_or_uuid)
      #     end
      #     
      #     # now reflect the relationships and work out which VO needs to be added to which
      #     if relation_model.is_many?
      #       relation[vo.name] << model
      #     else
      #       relation[vo.name] = model
      #     end          
      #   end
      #   
      #   # save our model, we're done!
      #   model.save        
      end
    end
  end
end