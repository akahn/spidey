require 'faraday'
require 'faraday_middleware'

module Spidey
  # Handles HTTP communication. Facilitates reuse of a single HTTP connection,
  # allowing for persistent connections
  class Connection
    CONNECTION_ERRORS = [Errno::ETIMEDOUT,
                         Faraday::Error::ClientError,
                         Faraday::Error::ConnectionFailed]

    def initialize
      @connection = Faraday.new do |builder|
        builder.use FaradayMiddleware::FollowRedirects, :limit => 4
        builder.adapter :net_http_persistent
      end
    end

    # Get the resource at `path` and return a Faraday::Response object
    def get(uri)
      begin
        @connection.get(uri)
      rescue *CONNECTION_ERRORS => e
        warn "#{uri}: #{e}"
        Faraday::Response.new
      end
    end

    # Get the resource at `path` and return its body as a string
    def body(path)
      get(path).body
    end

    def inspect
      "#<Spidey::Connection:#{object_id}>"
    end
  end
end
