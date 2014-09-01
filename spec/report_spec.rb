require 'helper'
require 'spidey/report'

describe Spidey::Report do
  let(:page) { Spidey::Page.new('http://localhost:8000') }
  subject(:report) { Spidey::Report.new("localhost:8000", [page]) }

  it 'starts with a header' do
    expect(report.render.lines.first).to match(/^# .* localhost:8000/)
  end

  it "lists a page's links" do
    links_list = "Links:\n    \\* /sub_page.html"
    expect(report.render).to match(links_list)
  end

  it "excludes the links section if none are found" do
    allow(page).to receive(:links) { [] }
    links_list = "Links:\n    \\* /sub_page.html"
    expect(report.render).to_not match(links_list)
  end
end
