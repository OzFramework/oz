module Oz
  class NoRouteToPageError < StandardError
    def initialize(source_page, target_page)
      super("No Route exists from #{source_page} to #{target_page}")
    end
  end
end