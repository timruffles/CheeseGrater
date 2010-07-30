require 'nokogiri'
module CheeseGrater 
  module Response
    class Xpath < Base
      
      include Logging
      
      def raw= doc
        @raw = doc.dup
        @document = make_doc(doc)
      end
      
      def make_doc raw
        @is_html ? ::Nokogiri::HTML(raw) : ::Nokogiri::XML(raw)
      end
      
      def query query, scope = @document
        to_q = make_doc(scope) rescue scope
        to_q.xpath(query)
      end
      
      def scalar_query query, scope = @document
        to_q = make_doc(scope) rescue scope
        if Array === query
          query.inject([]) do |results, query|
            results << xpath_to_scalar(to_q.at_xpath(query))
          end
        else
          xpath_to_scalar(to_q.at_xpath(query))
        end
      end
      
      protected
      
        def xpath_to_scalar selected
          case selected
          when Nokogiri::XML::Attr                         then selected.value
          when Nokogiri::XML::NodeSet, Nokogiri::XML::Node then node_or_set_value(selected)
          end
        end
      
        def node_or_set_value node
          @is_html ? node.inner_html : node.inner_text
        end
      
    end
  end
end