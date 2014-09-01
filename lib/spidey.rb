require 'uri'
require 'spidey/page'
require 'spidey/report'
require 'spidey/connection'
require 'spidey/crawler'

module Spidey
  # The main public API to be called by the spidey executable
  def self.scrape(url, max_depth = 3)
    results = Crawler.new(url, max_depth).crawl
    puts Report.new(url, results.values).render
  end

  # Create or return an existing Spidey::Connection object, to be used
  # throughout the session
  def self.connection
    @connection ||= Connection.new
  end

  def self.log_requests
    if @log_requests.nil?
      true
    else
      @log_requests
    end
  end

  # Controls whether to log requests to STDOUT
  def self.log_requests=(setting)
    @log_requests = setting
  end
end
