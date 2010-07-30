require 'time'
module CheeseGrater
  class Scraper
    module Helper
      class MuEvents < Base
        
        def format_vo_fields name, fields
          
          fields[:start_date] = fields[:start_date].to_s.gsub(/0$/,'').to_i

          super name, fields
        end
        
        def format_related_vo_fields name, fields
          if name == :Organiser
            fields[:url] = 'http://www.meetup.com/' + fields[:url]
          end
          super name, fields
        end
        
      end
    end
  end
end