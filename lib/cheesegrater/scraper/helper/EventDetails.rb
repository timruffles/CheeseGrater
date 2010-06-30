require 'time'
module CheeseGrater
  class Scraper
    module Helper
      class FnEventDetails < Base
        
        def format_vo_fields name, fields
          fields    = sanitize_fields([:title, :description, :start_date, :cost, :notes], fields)
          time_date = Sanitize.clean(fields[:start_date])
          
          remove ['Cost','Details','When', 'Event Contact Details'], [:cost, :description, :when, :notes], fields
          
          time          = Time.parse(time_date) rescue nil
          fallback_date = Date.parse(time_date) rescue nil unless time
          
          fields[:start_date] = time || fallback_date

          fields
        end
        
        def remove text, from, fields
          from.each do |field|
            fields[field].gsub!(text,'')
          end
        end

      end
    end
  end
end