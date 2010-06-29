module CheeseGrater
  module Handler
    class RailsModel
      
      def perform vo
        
        # grab the model that relates to the VO, and instantiate it
        model_class = const_get(vo.name)
        model = model_class.new( vo.fields )
        
        # the vo could have one of two things here, a hash of model names (eg Organiser) to UUIDs of
        # previously yielded Vos, or a hash of model names to Vos.
        vo.related_to.each_pair do |name, vo_or_uuid|
          
          related_model = const_get(name)
          
          # if it's a UUID, retrieve the model by that
          # if it's a VO, create the model using the VO's fields
          if vo_or_uuid.respond_to? :fields
            relation_model = related_model.new(vo_or_uuid.fields)
          else
            relation_model = related_model.find_by_uuid(vo_or_uuid)
          end
          
          # now reflect the relationships and work out which VO needs to be added to which
          if relation_model.is_many?
            relation[vo.name] << model
          else
            relation[vo.name] = model
          end          
        end
        
        # save our model, we're done!
        model.save        
      end
      
      
      
    end
  end
end