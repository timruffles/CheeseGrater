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
      
      def field path, item
        noko_result = make_doc(item).at_xpath(path) 
        case noko_result
          when Nokogiri::XML::Attr
            noko_result.value
          when Nokogiri::XML::Node
            @is_html ? noko_result.inner_html : noko_result.inner_text
          when Nokogiri::XML::NodeList
            raise RuntimeError "Xpath expression #{path} didn't result in a single item result"
        end
      end
      
      def items path
        @doc.xpath(path)
      end
      
    end
  end
end