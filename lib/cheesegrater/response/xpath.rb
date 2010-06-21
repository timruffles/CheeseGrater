module CheeseGrater 
  module Response
    class Xpath
      
      def initialize doc, is_html = false
        @doc = is_html ? ::Nokogiri::HTML(doc) : ::Nokogiri::XML(doc)
      end
      
      def query query
        
      end
    end
  end
end