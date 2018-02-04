require "cache/cache"
require 'json'

module Cache

  # Lookup the rate of a given currency in the cache
  #
  # @param iso [String] The string ISO code of the currency
  # @return [String, nil] The exchange rate, nil if the currency is not in the cache
  def rate(iso)
    begin
      cache = get_hash()
    rescue
      return nil
    end
    return cache[iso]
  end

  # Get data from the cache in the form of a hash.
  #
  # @return [String, nil] The hash of data from the cache.
  def get_hash
    begin
      cache_data = Cache.read()
    rescue
      raise IOError.new("Could not read the cache.")
    end
    match = cache_data.match(/.?\s?\{((.?\s?)+)\}/)
    if match[1] == nil
      raise RegexpError.new
    end
    json_string = "{#{match[1]}}"
    return JSON.parse(json_string)
  end
end
