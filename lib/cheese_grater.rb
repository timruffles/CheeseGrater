module CheeseGrater
  class Loader
    
    def load_scrapers scraper_groups = {}
      
      # load the inheritable characteristics and mix them into the scrapers
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
    
    # using the inherited args, create all scrapers
    def setup_scrapers scraper_setups, inherited = {}
      scrapers = {}
      scraper_setups.each_pair do |name, setup|
        
        # get setup
        complete_setup = prepare_scraper_setup(setup, inherited)
        # create all dependent scrapers
        dependent_scrapers = prepare_dependent_scraper_setups(setup, scraper_setups).each do |setup|
          Scraper.create(setup)
        end
        
        scrapers[name] = Scraper.create(complete_setup, dependent_scrapers)
        
      end
      scrapers
    end
    
    # allow setup to inherit
    def prepare_scraper_setup instance, inherited
      inherited.reject {|k, v| is_scraper? k}.deep_merge(instance.reject {|k, v| is_scraper? k})
    end
    
    # create dependent scrapers found in query
    def prepare_dependent_scraper_setups setup, scraper_setups
      
      dependents = (setup[:fields] || {}).reject do |key, val|
        is_scraper? key == false
      end
      
      completed = {}
      dependents.each_pair do |name, setup|
        begin
          completed[name] = scraper_setups[name].deep_merge(setup)
        rescue Exception => e
          raise "Could not find scraper definition " + name.to_s
        end
      end
      
      completed
    end
    
    # return all root scrapers
    def root_scrapers
      roots = []
      scrapers.each_pair do |group, scrapers_in_group|
        scrapers_in_group.each_pair do |key, val|
          roots << val if val.root
        end
      end
      roots
    end
    
    # scrapers loaded
    def scrapers
      (@scrapers ||= {})
    end
    
    
    private
    
    
    def is_scraper? key
      key.to_s =~  /^[A-Z]/
    end
    
  end 
end