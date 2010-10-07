require 'sanitize'
module CheeseGrater
  class Scraper
    module Helper
      class Base
        
        include RubADub
        
        # TODO add exclude method to exclude various fields from filter/sanitize chain
        cleaners :event => [
          :strip!,
          :flatten_multiples,
          {:exclude => :url, :actions => [:sanitize, :basic]}
        ], :organiser => [
          :strip!,
          :flatten_multiples,
          {:exclude => :url, :actions => [:sanitize, :basic]}
        ], :scrapers => [
          :strip!,
          {:exclude => :url, :actions => [:sanitize]}
        ]
        
        # TODO add a br squeeze
        BASIC = {:elements => ['p','br', 'a', 'ol', 'ul', 'li'],
                :attributes => {'a' => ['href', 'title']},
                :protocols => {'a' => {'href' => ['http', 'https', 'mailto']}}}
        COMPLETE = {}
        
        def format_vo_fields vo_name, fields
          clean vo_name.to_s.downcase.to_sym, fields
        end

        def format_scraper_fields name, fields
          clean :scrapers, fields
        end

        def sanitize field, level = BASIC
           Sanitize.clean(field, level) rescue value
        end
        
        def flatten_multiple field
          next unless value.respond_to? :each
          field.reject(&lambda {|v| /^[\t\s]*$/ =~ v || v == nil}).map(&lambda {|v| v.strip}).join(', ')
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