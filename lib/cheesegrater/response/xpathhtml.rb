require 'nokogiri'
module CheeseGrater 
  module Response
    class XpathHtml < Xpath
      def initialize
         @is_html = true # TODO DI for this
      end
    end
  end
end