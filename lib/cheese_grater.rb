module CheeseGrater
  class Loader
    def load_scrapers scraper_groups = {}
      # all scraper groups, load the inheritable characteristics and mix them into the scrapers
      scraper_groups.keys_to_symbols.each_pair do |group, included|
        
        inheritable = {}
        scraper_setups  = {}
        
        # load setups
        included.each_pair do |key, value|
          target = is_scraper?(key) ? scraper_setups : inheritable
          target[key] = value
        end
        
        # create each scraper when whole setup is present
       scrapers[group] = setup_scrapers(scraper_setups, inheritable)
      end
    
    
    end
    def setup_scrapers scraper_setups, inherited
      scrapers = {}
      scraper_setups.each_pair do |name, setup|
        
        # get setup
        complete_setup = prepare_scraper_setup(setup, inherited)
        # create all dependent scrapers
        dependent_scrapers = setup_scrapers((complete_setup[:fields] || {}).delete_if do |key, val|
          is_scraper? key == false
        end, inherited)
        
        scrapers[name] = Scraper.create(complete_setup, dependent_scrapers)
        
      end
      scrapers
    end
    def prepare_scraper_setup instance, inherited
      inherited.reject {|k, v| is_scraper? k}.deep_merge(instance.reject {|k, v| is_scraper? k})
    end
    
    def scrapers
      (@scrapers ||= {})
    end
    private
    def is_scraper? key
      key.to_s =~  /^[A-Z]/
    end
    
   
  end 
end