require "cache/cache"
require 'json'

module Cache

  # Lookup the rate of a given currency in the cache
  #
  # @param iso [String] The string ISO code of the currency
  # @return [String, nil] The exchange rate, nil if the currency is not in the cache
  def rate(from, to)
    cache = get_hash()
    return cache["#{from}>#{to}"]
  rescue
    return nil
  end

  # Append an entry to the cache.
  #
  # @note This method overwrites an exisiting entry in the cache.
  def store(from, to, rate)
    begin
      current_cache = get_hash()
      hash = {
        "#{from}>#{to}" => rate
      }
      new_cache = current_cache.merge(hash) if current_cache
      Cache.write(JSON[new_cache]) if current_cache
      Cache.write(JSON[hash]) if !current_cache
    rescue => e
      raise e
    end
    return new_cache
  end

  # Get data from the cache in the form of a hash.
  #
  # @return [String, nil] The hash of data from the cache.
  private def get_hash
    begin
      cache_data = Cache.read()
    rescue
      raise IOError.new("Could not read the cache.")
    end
    match = cache_data.match(/.?\s?\{((.?\s?)+)\}/)
    if match[1] == nil
      return nil
    end
    json_string = "{#{match[1]}}"
    return JSON.parse(json_string)
  end

  def is_outdated?
    seconds_in_day = 86400
    true if Cache.stale(seconds_in_day)
    false
  end

end
