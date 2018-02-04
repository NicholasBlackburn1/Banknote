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
  end

  it "reads json data" do
    expect(Cache.write('{"USD>GBP": 1.5}')).to be 0
    expect(Cache.rate("USD", "GBP")).to eq(1.5)
  end

  # it "checks timecodes" do
  #   expect(Cache.write("DATA")).to be 0
  #   puts("  Testing timecodes...")
  #   sleep(2)
  #   expect(Cache.stale(1)).to be true
  # end

  it "knows when a value does not exist" do
    expect(Cache.rate("FKE", "MNY")).to be nil
  end

  it "stores a new value in the cache" do
    expect(Cache.write('{"USD>GBP": 1}')).to be 0
    expect(Cache.rate("USD", "GBP")).to eq(1)
    expect(Cache.store("USD", "EUR", 1.2)).not_to be nil
    expect(Cache.rate("USD", "EUR")).to eq(1.2)
  end

  it "stores to an empty cache" do
    expect(Cache.store("USD", "JPY", 1.2)).not_to be nil
    expect(Cache.rate("USD", "JPY")).to eq(1.2)
  end

  after :each do
    Cache.purge()
  end
end
