require 'helper'
require 'spidey/page'
require 'spidey/connection'

describe Spidey::Page do
  subject(:page) { Spidey::Page.new('http://localhost:8000/') }

  it 'finds relative links' do
    expect(page.links).to include('/sub_page.html')
  end

  it 'finds absolute links' do
    expect(page.links).to include('http://localhost:8000/promotion.html')
  end

  it 'excludes links to external sites' do
    expect(page.links).not_to include('http://www.facebook.com')
  end

  it 'excludes links that appear to be files' do
    expect(page.links).not_to include('/menu.pdf')
  end
end
