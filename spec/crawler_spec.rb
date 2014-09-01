require 'helper'
require 'spidey/crawler'

describe Spidey::Crawler do
  it "should find child pages" do
    results = Spidey::Crawler.new('http://localhost:8000', 100).crawl
    expect(results.keys).to eq(["http://localhost:8000/",
                                "http://localhost:8000/sub_page.html",
                                "http://localhost:8000/promotion.html",
                                "http://localhost:8000/sub_sub_page.html"])
  end

  it "should limit depth of link traversal" do
    results = Spidey::Crawler.new('http://localhost:8000', 2).crawl
    expect(results.keys).to eq(["http://localhost:8000/",
                                "http://localhost:8000/sub_page.html",
                                "http://localhost:8000/promotion.html"])
  end

  it "should contain links between pages" do
    results = Spidey::Crawler.new('http://localhost:8000', 1).crawl
    expect(results.values.first.links).to eq(["/sub_page.html",
                                              "http://localhost:8000/promotion.html"])
  end
end
