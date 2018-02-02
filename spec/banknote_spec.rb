RSpec.describe Banknote do
  it "has a version number" do
    expect(Banknote::VERSION).not_to be nil
  end

  it "requires currency class" do
    expect(Banknote::Currency.new).not_to be nil
  end

  it "writes to a cache file" do
    expect(Cache.write("Cache file written.")).to be 0
  end

  it "checks timecodes" do
    expect(Cache.write("DATA")).to be 0
    sleep(2)
    expect(Cache.stale(1)).to be true
  end

  # it "reads a cache file" do
  #   expect(Cache.write("READ")).to be 0
  #   expect(Cache.read()).to eq("READ")
  # end
end
