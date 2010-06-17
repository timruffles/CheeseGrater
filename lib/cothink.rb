cothink_lib_dir = File.dirname(__FILE__) + '/cothink'
Dir["#{cothink_lib_dir}/*.rb"].each { |f| load(f) }
