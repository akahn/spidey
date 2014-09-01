$LOAD_PATH << './lib'

require 'spidey'
require 'webrick'
require 'logger'

Spidey.log_requests = false

def start_server
  root = File.expand_path('../fixtures/site', __FILE__)
  Thread.new do
    server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => root,
                                     :Logger => WEBrick::Log.new("/dev/null"), :AccessLog => [])
    server.start
  end
end

start_server
