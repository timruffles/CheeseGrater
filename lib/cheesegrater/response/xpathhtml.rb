require 'nokogiri'
module CheeseGrater 
  module Response
    class Xpathhtml < Xpath
      def initialize
         @is_html = true # TODO DI for this
      end
    end
  end
end