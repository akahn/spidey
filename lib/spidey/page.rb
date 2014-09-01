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

    def scan
      links
      stylesheets
      images
      scripts
      self
    end

    # Find internal (linking to the same domain) hyperlinks on the page,
    # excluding links to files
    def links
      links = html_document.xpath('//a').map {|node| node['href']}.compact.uniq
      links.select do |link|
        !file_link?(link) && internal_link?(link)
      end
    end

    def stylesheets
      html_document.xpath("//link[@rel='stylesheet']").map {|node| node['href']}.select {|src| internal_link?(src) }
    end

    def images
      html_document.xpath("//img[@src]").map {|node| node['src']}.select {|src| internal_link?(src) }
    end

    def scripts
      html_document.xpath("//script[@src]").map {|node| node['src']}.select {|src| internal_link?(src) }
    end

    private

    def html_document
      @document ||= Nokogiri::HTML(@connection.body(@uri))
    end

    def internal_link?(url)
      begin
        # Match /foo but not //foo
        url =~ Regexp.new("^/[^/]") ||
          URI(url).host == @uri.host
      rescue URI::InvalidURIError
        # Twitter links are not valid URIs
        false
      end
    end

    def file_link?(url)
      file_matcher = /\.jpg|\.gif|\.png|\.pdf|\.eps$/
      url =~ file_matcher
    end
  end
end
