require 'sanitize'
module CheeseGrater
  class Scraper
    module Helper
      class Base
        
        # TODO add exclude method to exclude various fields from filter/sanitize chain
        @exclude = {:url => [:sanitize, :flattern]}
        
        
        # TODO add a br squeeze
        BASIC = {:elements => ['p','br', 'a', 'ol', 'ul', 'li'],
                :attributes => {'a' => ['href', 'title']},
                :protocols => {'a' => {'href' => ['http', 'https', 'mailto']}}}
        COMPLETE = {}
        
        def format_vo_fields name, fields
          default_treatment(fields)
        end

        def format_scraper_fields name, fields
          default_treatment(fields)
        end

        def format_related_vo_fields name, fields
          default_treatment(fields)
        end
        
        def sanitize_all fields, setup = BASIC
          fields.each_pair do |field, value|
            fields[field] = Sanitize.clean(value, setup) rescue value
          end
          fields
        end
        
        def default_treatment fields
          trim_all(sanitize_all(flatten_multiples(fields)))
        end
        
        def flatten_multiples fields
          fields.each_pair do |field, value|
            next unless value.respond_to? :each
            fields[field] = value.reject(&lambda {|v| /^[\t\s]*$/ =~ v || v == nil}).map(&lambda {|v| v.strip}).join(', ')
          end
          fields
        end
        
        def sanitize_fields which, fields, setup = BASIC
          
          which.each do |field|
            next unless fields[field]
            fields[field] = Sanitize.clean(fields[field], setup)
          end
          
          fields 
        end
        
        def trim_all fields
          fields.each_key do |key|
            fields[key].strip! rescue nil
          end
        end
        
        def remove what_by_field, fields
          what_by_field.each do |field, to_remove|
            (to_remove.to_a rescue [to_remove]).each do |remove|
              fields[field].gsub!(remove,'') if fields[field]
            end
          end
        end
        
        # matches loosley telephone number like things
        def optimistic_telephone text
          text.scan(optimistic_telephone_re).join(', ')
        end
        
        # matches loosely email like things, including simple obfuscation techniques
        # eg: html encoding, blah at blah dot com
        def optimistic_email text
          text = CGI.unescapeHTML(text) # remove html entitisation
          text.scan(optimistic_email_re).join(', ')
        end
        
        
        def optimistic_telephone_re
          /[\s\d+\(\)\[\]#_,\.-]{6,20}/
        end
        
        def optimistic_email_re
          # aiming to match tim@blah.com, tim @ blah.com, tim (at) blah.com etc
          /[\w\.-_]+(\s{0,2})   # wordy bits, followed by one to two spaces group 1
            (?:@|\(?at\)?)      # with either an at, or the word at with optional parens around
            \1
            (?:
              [\w\-_]+          # followed by some words etc, with at least one of a . or the word dot
              (?:\.|\s\.\s|\s?dot\s?)
              [\w\-_]+          # the tld
            )+/x
        end
        
      end
    end
  end
end