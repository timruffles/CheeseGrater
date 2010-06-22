# When /I run "([^"]*)" with files specified relative to executable/ do |cmd|
# 
#   file_re = /[\w_-]*/
#   files = cmd.scan(file_re)
#   absoluteised = files.map do |file|
#     "#{CheeseGrater::CukeRootDir}/#{file}"
#   end
#   
#   cmd.gsub!(file_re,'%s')
#   
#   run(unescape(sprintf(cmd,files)))
# end