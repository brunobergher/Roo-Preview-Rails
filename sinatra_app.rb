require "sinatra"
require "optparse"

options = {}
OptionParser.new do |opts|
  opts.on("-p", "--port PORT", Integer, "Port to listen on") { |p| options[:port] = p }
end.parse!

set :port, options[:port] || 3001

get "/" do
  <<~HTML
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Preview</title>
      </head>
      <body style="margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;background:#ff0000;color:#ffffff;font-family:system-ui,sans-serif;">
        hello
      </body>
    </html>
  HTML
end
