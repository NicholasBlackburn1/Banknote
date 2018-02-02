require "cache/cache"
require 'json'

module Cache

  def rate(iso)
    begin
      cache = parse()
    rescue
      return nil
    end
    return cache[iso]
  end

  def parse
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
