require "symbols/symbols"
module Banknote
  # An ISO currency code
  class Symbol
    def self.is_valid(string)
      string.upcase[/^[A-Z]{3}$/] ? true : false
    end
  end
end
