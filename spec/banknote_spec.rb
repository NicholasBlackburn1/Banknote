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

  it "reads a cache file" do
    expect(Cache.write("READ")).to be 0
    expect(Cache.read().slice(/READ/)).to eq("READ")
  end

  it "clears the cache" do
    expect(Cache.purge()).to be 0
    expect(Cache.read()).to eq("")
  end

  it "reads json data" do
    expect(Cache.write('{"test": "data"}')).to be 0
    expect(Cache.rate("test")).to eq("data")
  end

  it "checks timecodes" do
    expect(Cache.write("DATA")).to be 0
    puts("  Testing timecodes...")
    sleep(2)
    expect(Cache.stale(1)).to be true
  end

  it "knows when the cache is empty" do
    expect(Cache.rate("not there")).to be nil
  end

  after :all do
    Cache.purge()
  end
end
