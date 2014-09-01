module Spidey
  # Carries out the process of crawling a website by fetching pages and
  # extracting links, limited by a maximum depth
  class Crawler
    # initial_url: the root URL from which to crawl
    # max_depth: the maximum depth, including the initial URL. For example, a
    # max_depth of three will include the initial_url as well as children and
    # grandchildren
    def initialize(initial_url, max_depth = 3)
      @initial_url = append_path(initial_url)
      @max_depth = max_depth
    end

    # Crawl the desired site, returning a Hash of URL keys pointing to Page
    # object values
    def crawl
      completed = {}
      to_crawl = [Spidey::Page.new(@initial_url)]

      while page = to_crawl.shift do
        break if page.depth == @max_depth

        if !completed.has_key?(page.uri.to_s)
          STDERR.puts "Fetching #{page.uri.to_s}" if Spidey.log_requests
          page.scan.links.each do |link|
           to_crawl << Spidey::Page.new(@initial_url.merge(link), page.depth + 1)
          end
          completed[page.uri.to_s] = page
        end
      end

      completed
    end

    private

    # If no path was provided, set path to '/'. Prevents example.com and
    # example.com/ from being crawled separately.
    def append_path(initial_url)
      uri = URI(initial_url)
      if uri.path == ''
        uri.merge('/')
      else
        uri
      end
    end
  end
end
