module OzFramework
  class InvalidElementSelectorError < StandardError
    def initialize(name, selector_hash, selector_whitelist)
      msg = "Tried to select an element named [#{name}] using [#{selector_hash}], allowed selectors only include [#{selector_whitelist}]"
    end
  end
end