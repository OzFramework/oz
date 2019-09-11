module Oz
  # Error class that raises when a page is not found in the router registry, pages are added when
  # CorePage is included in their inheritance chain.  Example:
  # SomePage < SomeBasePage
  # SomeBasePage < SomeRootPage
  # SomeRootPage < CorePage
  class NoPageInRegistryError < StandardError
    def initialize(page)
      msg = "No PageClass exists in the registry for #{page}, Ensure that the page inherits from CorePage, or that it exists."
      super(msg)
    end
  end
end