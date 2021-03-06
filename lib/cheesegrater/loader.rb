module CheeseGrater
  
  # Loader handles config hashes, turning them into a list of scrapers ready to roll, with
  # all shared setup and related scrapers.
  class Loader
    
    include Logging
    
    # TODO: make sure scrapers get all the scrapers they need, with the same paths as in config file
    # at the momenent they do, as each scraper has a unique name
    def load config
      
      # TODO better place for this?
      if config['log4r_config']
        ycfg = Log4r::YamlConfigurator
        # ycfg['foo'] = bar          # replaces instances of #{foo} in the YAML with bar
        ycfg.load_yaml_string(YAML.dump(config))
      end
      
      # gah - log4r expects strings, so only convert to symbols here
      config.keys_to_symbols!
      
      # load all scrapers, and mix all shared fields into them
      config[:scrapers].each_pair do |group, included|
        
        shared_setup = {}
        scraper_setups  = {}
        
        # load setups
        included.each_pair do |key, value|
          target = if is_scraper?(key)
                     logger.info "Loading scraper #{group}::#{key}"
                     scraper_setups
                   else
                     shared_setup
                   end

          target[key] = value
        end
        
        # create each scraper when whole setup is present
       scrapers[group] = setup_scrapers(scraper_setups, shared_setup);
      end if config[:scrapers]
    end
    
    # return all root scrapers
    def root_scrapers
      roots = []
      scrapers.each_pair do |group, scrapers_in_group|
        scrapers_in_group.each_pair do |key, val|
          roots << val if val.is_root?
        end
      end
      roots
    end
    
    # scrapers loaded
    def scrapers
      (@scrapers ||= {})
    end
    
    protected
    
    # using the shared_setups args, create all scrapers
    def setup_scrapers scraper_setups, shared_setups = {}
      scrapers = {}
      scraper_setups.each_pair do |name, setup|
        
        # get setup
        complete_setup = combine_scraper_with_shared_setup(setup, shared_setups)
        # create all related scrapers
        related_scrapers = prepare_related_scraper_setups(setup, scraper_setups)
        
        # set name and create scraper
        complete_setup.merge!(:name => name)
        scrapers[name] = Scraper.create(complete_setup, related_scrapers)
      end
      # TODO the information defecit is solved... nastily
      scrapers.each_pair do |name, scraper|
        scraper.related_scrapers.merge!(scrapers)
      end
      scrapers
    end
    
    # allow setup to inherit
    def combine_scraper_with_shared_setup scraper_setup, shared_setup
      shared_setup.deep_merge(scraper_setup)
    end
    
    # create related scrapers found in query
    def prepare_related_scraper_setups setup, scraper_setups
      
      relateds = (setup[:related_to] || {})
      
      prepared = {}
      relateds.each_pair do |name, setup|
        begin
          prepared[name] = scraper_setups[name].deep_merge(setup)
        rescue Exception => e
          raise "Could not find scraper definition " + name.to_s
        end
      end
      
      prepared
    end
    
    def is_scraper? key
      key.to_s =~  /^[A-Z]/
    end
    
  end
end