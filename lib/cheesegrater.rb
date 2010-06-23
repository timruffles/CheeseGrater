
lib_dir = File.dirname(__FILE__)
require lib_dir + '/cheesegrater/coreextensions'
require lib_dir + '/cheesegrater/logging'
def _____req_all file
  Dir.glob(file + '/*').each do |file|
    if (/^\.*$/ =~ file) === nil && File.directory?(file)
      _____req_all(file)
    else
      require file
    end
  end
end
_____req_all(lib_dir + '/cheesegrater')