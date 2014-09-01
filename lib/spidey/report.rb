require 'erb'

module Spidey
  # Produces a Markdown-based report of a site's pages and links
  class Report
    def initialize(uri, pages)
      @uri = uri
      @pages = pages
    end

    def render
      template = ERB.new(self.class.template, nil, '-')
      template.result(binding)
    end

    def self.template
      <<-ERB
# Spidey Report for <%= @uri %>

<% @pages.each do |page| -%>
* <%= page.uri %>

  Links:

<% page.links.each do |link| -%>
  * <%= link %>
<% end -%>
      ERB
    end
  end
end
