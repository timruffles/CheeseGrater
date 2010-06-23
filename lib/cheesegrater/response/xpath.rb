require 'nokogiri'
module CheeseGrater 
  module Response
    class Xpath < Base
      
      def initialize doc, is_html = false
        @doc = make_doc(doc)
        @is_html = is_html
      end
      
      def make_doc raw
        @is_html ? ::Nokogiri::HTML(raw) : ::Nokogiri::XML(raw)
      end
      
      def items path, fields
        @doc.xpath(path).each do |item|
          filled_in_fields = {}
          fields.each_pair do |field, field_path|
            selected = item.at_xpath field_path
            result = case selected
                     when Nokogiri::XML::Attr                         then selected.value
                     when Nokogiri::XML::NodeSet, Nokogiri::XML::Node then node_or_set_value(selected)
                     end
            filled_in_fields[field] = result
          end
          yield filled_in_fields
        end
      end
      
      protected
      
      def node_or_set_value node
        @is_html ? node.inner_html : node.inner_text
      end
      
    end
  end
end