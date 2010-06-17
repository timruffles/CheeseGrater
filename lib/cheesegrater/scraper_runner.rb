class ScraperRunner
  @queue = :scrapers
  def constantize(camel_cased_word)
   unless /\A(?:::)?([A-Z]\w*(?:::[A-Z]\w*)*)\z/ =~ camel_cased_word
     raise NameError, "#{camel_cased_word.inspect} is not a valid constant name!"
   end

   Object.module_eval("::#{$1}", __FILE__, __LINE__)
  end
  def perform(marshaled)
    scraper = Marshal.load(marshaled)
    scraper.scrape do |yielded|
      if yielded.respond_to? :scrape
         Resque.enqueue(ScraperRunner,Marshal.dump(yielded))
      else
         Resque.enqueue(EventSaver,Marshal.dump(yielded))
      end
    end
  end
end