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
      links = html_document.xpath('//a/@href').map(&:value).uniq
      links.select do |link|
        !file_link?(link) && internal_link?(link)
      end
    end

    def stylesheets
      select_internal(html_document.xpath("//link[@rel='stylesheet']/@href").map &:value)
    end

    def images
      select_internal(html_document.xpath("//img/@src").map &:value)
    end

    def scripts
      select_internal(html_document.xpath("//script/@src").map &:value)
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

    def select_internal(paths)
      paths.select {|path| internal_link?(path) }
    end

    def file_link?(url)
      file_matcher = /\.jpg|\.gif|\.png|\.pdf|\.eps$/
      url =~ file_matcher
    end
  end
end
