require 'erb'

module Spidey
  # Produces a Markdown-based report of a site's pages and links
  class Report
    def initialize(uri, pages)
      @uri = uri
      @pages = pages
    end

    def render
      template = ERB.new(File.read(File.expand_path('report.erb', __dir__)), nil, '-')
      template.result(binding)
    end
  end
end
