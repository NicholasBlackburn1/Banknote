module Banknote
  # Represents an amount, and type of currency.
  class Currency
    # Create a new currency object
    #
    # @param iso [Number] The amount of currency
    # @param amount [String] The ISO currency code. (USD, EUR, etc.)
    def initialize(amount, iso)
      nil if !ISO.valid
      @amount = amount
      @symbol = iso
    end

    # Convert a currency to another currency
    #
    # @param to [String] The ISO currency code. (USD, EUR, etc.)
    #
    # @return [Currency] A new currency object from the conversion
    def convert(to)

    end
  end
end
