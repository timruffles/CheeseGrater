require "resque"
require "yaml"
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite",
  #:host => "localhost",
  :database => "thebusinessdiary_development"
  #:username => "root",
  #:password => ""
)

# freaks out loading acts as taggable on
#models_dir = File.dirname(__FILE__) + '/../../appq/app/models'
#load("#{models_dir}/event.rb")
#load("#{models_dir}/organisation.rb")

module CheeseGrater
  module Handler
    class Event < ActiveRecord::Base
      belongs_to :organisation
      
      def self.smart_find_or_initialize(fields)
        # TODO - find by title + start_date(time)
        self.new(fields)
      end
    end

    class Organisation < ActiveRecord::Base
      has_many :events
    end

    class RailsModel
      @queue = :save
      attr_accessor :vo      
            
      # step through following, make sure works...
      
      def self.perform(vo)
        vo = YAML::load(vo) # unserialise
                
        # grab the model that relates to the VO, and instantiate it
        model_class = ::Handler.const_get(vo.name) # activerecord redefines const_get, so scope receiver
        
        # TODO - handle duplicates across multiple sources here
        
        model = model_class.smart_find_or_initialize(vo.fields)
        
        puts "model:"
        puts model.to_yaml
        puts "======================="
        
        puts "related:"
        puts vo.related_to.inspect
        puts vo.related_to.length
        puts "======================="
        
        # the vo could have one of two things here, a hash of model names (eg Organiser) to UUIDs of
        # previously yielded Vos, or a hash of model names to Vos.
        vo.related_to.each_pair do |name, vo_or_uuid|
          puts "each_pair"

          related_model = ::Handler.const_get(name)          
          p related_model

#         # if it's a UUID, retrieve the model by that
#         # if it's a VO, create the model using the VO's fields
#         if vo_or_uuid.respond_to? :fields
#           puts "new related model:"
#           relation_model = related_model.new(vo_or_uuid.fields)
#         else
#           puts "find existing related model by uuid:"
#           relation_model = related_model.find_by_uuid(vo_or_uuid)
#         end
#
#         puts related_model.inspect
#         puts "======================="
#         puts "======================="
#         puts "======================="
#          
#          # # now reflect the relationships and work out which VO needs to be added to which
#          # if relation_model.is_many?
#          #   relation[vo.name] << model
#          # else
#          #   relation[vo.name] = model
#          # end          
        end
      
        # save our model, we're done!
        puts "save?"
        puts model.save        
      end
    end
  end
end