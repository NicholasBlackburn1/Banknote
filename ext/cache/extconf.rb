require 'mkmf'

headers = [
  "ruby",
  "time",
  "stdio",
  "stdlib",
]

headers.each do |header|
  unless have_header "#{header}.h"
    abort "FATAL: Missing header #{header}.h"
  end
end

create_makefile('cache')
