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
      links = extract_attribute_values('//a/@href').uniq
      links.select do |link|
        !file_link?(link) && internal_link?(link)
      end
    end

    def stylesheets
      select_internal(extract_attribute_values("//link[@rel='stylesheet']/@href"))
    end

    def images
      select_internal(extract_attribute_values("//img/@src"))
    end

    def scripts
      select_internal(extract_attribute_values("//script/@src"))
    end

    private

    # Fetch and parse the page content and return attribute values according to
    # an XPath selector
    def extract_attribute_values(xpath_expression)
      @document ||= Nokogiri::HTML(@connection.body(@uri))
      @document.xpath(xpath_expression).map(&:value)
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
