class BusinessLink < UrlScraper
  def scrape
    
    xpath = self.load_url_xpath(@url)
    
    # all event dates in the future save '99', which is all dates and won't
    # work without additional search paramters
    (xpath/'#eventDate option').each do |option|
      unless option['value'].to_i == 99
        yield(BusinessLinkLevel2.new("http://online.businesslink.gov.uk/bdotg/action/eventsearch?keywords=&location=-999&date=#{option['value']}&submit=Go&page=1")) 
      end
    end
  end
end

class BusinessLinkLevel2 < UrlScraper
  Source = 'Business Link'
  def scrape
   
    xpath = self.load_url_xpath(@url)
    
    (xpath/'.resultnav p a:last-of-type').each do |link| 
        yield(BusinessLinkLevel2.new(link['href'])) if 'Next' == link.inner_html.to_s
    end
    
    (xpath/'.result-info').each do |event_wrap|
      # split on all titles, reparse each chunk to make it simple to access event elements
      event_wrap.inner_html.split('<h3>').each do |event|
        next unless event.include?('</h3>')
        e_xpath = self.load_str_xpath('<h3>' + event)
        
        rows = (e_xpath/'table tr')
        
        time = Time.parse((rows[0]/'td span')[0].inner_html)
        event_data = [(e_xpath/'h3')[0].inner_html, #name
                      (e_xpath/'p')[0].inner_html, #description
                      time, # time
                      (rows[1]/'td span')[0].inner_html, #location
                      (e_xpath/'a')[0]['href'], #link
                      Source, # source
                      Source]
        yield(EventVo.new(*event_data))
      end
    end
    
    
  end
end