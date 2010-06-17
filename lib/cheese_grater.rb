module CheeseGrater
  class Loader
    def load_scrapers scraper_groups = []
      inheritable = {}
      # all scraper groups, load the inheritable characteristics and mix them into the scrapers
      scraper_groups.each do |group, included|
        scrapers  = {}
        included.each_pair do |key, value|
          (key =~ /^[A-Z]/ ? scrapers : inheritable)[key] = value 
        end
      
        # create each scraper
        scrapers.each_pair do |name, setup|
        
          ((@scrapers ||= {})[group] ||= {})[name] = Scraper.create(prepare_scraper_setup)

        end
      
      end
    
    
    end
    def prepare_scraper_setup instance, mixins
      mixins.merge(instance)
    end
  end 
end