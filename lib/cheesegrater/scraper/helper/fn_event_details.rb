require 'time'
module CheeseGrater
  class Scraper
    module Helper
      class FnEventDetails < Base
        
        def format_vo_fields name, fields
          
          fields    = sanitize_fields([:description, :location], fields)
          fields    = sanitize_fields([:title, :start_date, :cost, :notes], fields, COMPLETE)
          
          # linearise location TODO make a descision about what to do with these lists
          fields[:location] = fields[:location].gsub!(/<br\s?\/?>/,",\n")
          
          remove({:cost => 'Cost', :description => 'Details', :when => 'When', :notes => 'Event Contact Details', :location => 'Venue'}, fields)
          
          # get as good as time data as we can
          time_date     = Sanitize.clean(fields[:start_date])
          time          = Time.parse(time_date) rescue nil
          fallback_date = (Date.parse(time_date) rescue nil) unless time

          # pull as much as poss out
          fields[:start_date] = time || fallback_date
          fields[:telephone]  = optimistic_telephone(fields[:notes])
          fields[:email]      = optimistic_email(fields[:notes])

          super name, fields
        end
        
        def format_related_vo_fields name, fields
          if name == :Organiser
            
            remove({:name => 'Organised By'}, fields)
            fields = sanitize_fields([:name], fields, COMPLETE)
            
          else
            super name, fields
          end
        end
        
      end
    end
  end
end