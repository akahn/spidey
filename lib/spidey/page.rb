require 'nokogiri'

module Spidey
  class Page
    attr_reader :uri, :depth

    # url: String of the URL to request
    # connection: a Connection object
    # depth: keeps track of how deep in a site's structure this page is
    def initialize(url, depth = 0)
      @connection = Spidey.connection
      @uri = URI(url)
      @depth = depth
    end

    # Request the body of the page, scan it for hyperlinks
    def links
      @links ||= begin
        body = @connection.body(@uri)
        links = Nokogiri::HTML(body).xpath('//a').map {|node| node['href']}.compact.uniq
        links.select do |link|
          !file_link(link) && (relative(link) || internal(link))
        end
      end
    end

    private

    def relative(url)
      url.start_with?('/')
    end

    def internal(url)
      begin
        URI(url).host == @uri.host
      rescue URI::InvalidURIError
        # Twitter links are not valid URIs
        false
      end
    end

    def file_link(url)
      file_matcher = /\.jpg|\.gif|\.png|\.pdf|\.eps$/
      url =~ file_matcher
    end
  end
end
