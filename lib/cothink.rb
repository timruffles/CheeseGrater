cothink_lib_dir = File.dirname(__FILE__) + '/cothink'
Dir.new(cothink_lib_dir).select {|f| f !~ /^\.+/ }.each do |scraper|
  require cothink_lib_dir + '/' + scraper.gsub!('.rb','')
end