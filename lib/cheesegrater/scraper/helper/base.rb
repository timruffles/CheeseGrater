require 'sanitize'
module CheeseGrater
  class Scraper
    module Helper
      class Base
        
        def format_vo_fields name, fields
          fields
        end

        def format_scraper_fields name, fields
          fields
        end

        def format_related_vo_fields name, fields
          fields
        end
        
        def sanitize_fields which, fields
          
          which.each do |field|
            next unless fields[field]
            fields[field] = Sanitize.clean(fields[field], :elements => ['a', 'ul', 'li', 'h1', 'h2', 'h3', 'h4', 'h5'],
                :attributes => {'a' => ['href', 'title']},
                :protocols => {'a' => {'href' => ['http', 'https', 'mailto']}})
            
          end
          
          fields 
        end
        
        def optimistic_telephone text
          test.scan(optimistic_telephone_re).join(' ')
        end
        
        def optimistic_telephone_re
          /[\s\d+\(\)\[\]#_,\.-]{5,35}/
        end
        
        def optimisitic_email text
          text = CGI.unescapeHTML(text) # remove html entitisation
        end
        
        def optimistic_email_re
          /[\w\.-_]+(\s{0,2})   # wordy bits, followed by one to two spaces group 1
            (?:@|\(?at\)?)      # with either an at, or the word at, with parens around them if present
            \1
            (?:
              (?:[\w\-_])+      # followed by some words etc, with at least one of a . or the word dot
              (?:\.|\s?dot\s?) 
              (?:[\w\-_])+
            )+/x
        end
        
      end
    end
  end
end