require 'helper'

describe Spidey::Connection do
  it "loads the body of a page" do
    expect(Spidey::Connection.new.body("http://localhost:8000/")).to \
      eq(File.read("spec/fixtures/site/index.html"))
  end
end
