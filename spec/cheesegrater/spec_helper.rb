require "rubygems"
require "bundler"
Bundler.setup(:default, :test)

lib_dir = File.dirname(__FILE__) + "/../../lib/"
require lib_dir + 'cheese_grater'
require lib_dir + 'cheesegrater/coreextensions'
def _____req_all file
  Dir.glob(file + '/*').each do |file|
    if (/^\.*$/ =~ file) === nil && File.directory?(file)
      _____req_all(file)
    else
      require file
    end
  end
end

_____req_all(lib_dir + 'cheesegrater')