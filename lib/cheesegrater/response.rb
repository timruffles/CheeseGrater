 def load_url_xpath(url)
    return open(url) { |f| Hpricot(f) }
  end
  def load_str_xpath(str)
    return Hpricot.parse(str)
  end