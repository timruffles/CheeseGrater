module CheeseGrater
  module Handler
    class RailsModel
      
      def perform vo
        
        model_class = const_get(vo.name)
        model = model_class.new( vo.fields )
        
        vo.related_to.each_pair do |name, uuid|
          
          related_model = const_get(name)
          relation = related_model.find_by_uuid(uuid)
          
          if relation.is_many?
            relation[vo.name] << model
          else
            relation[vo.name] = model
          end
          
        end
        
        
        
      end
      
      
      
    end
  end
end