require "sinatra"
require "optparse"

options = {}
OptionParser.new do |opts|
  opts.on("-p", "--port PORT", Integer, "Port to listen on") { |p| options[:port] = p }
end.parse!

set :port, options[:port] || 3001

get "/" do
  "hello"
end
