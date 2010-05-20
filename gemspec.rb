spec = Gem::Specification.new do |s| 
  s.name = "cothink-eventscraper"
  s.version = "0.0.1"
  s.author = "Tim Ruffles; Daniel Morris"
  s.email = "hello@cothink.co.uk"
  s.homepage = "http://cothink.co.uk"
  s.platform = Gem::Platform::RUBY
  s.summary = "Scrape event sites of their precious cargo"
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "eventscraper"
  s.test_files = FileList["{spec}/**/*spec.rb"].to_a
  s.has_rdoc = true
  candidates = Dir.glob("{lib,scripts,spec}")
  files:candidates.delete_if do |item|
    item.include?(".")
  end
  s.extra_rdoc_files = ["README"]
  s.add_dependency("hpricot")
  s.add_dependency("json_pure")
  s.add_dependency("resque")
  s.add_dependency("ruby-openid")
end