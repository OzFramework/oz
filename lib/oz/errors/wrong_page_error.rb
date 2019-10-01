module OzFramework
  class WrongPageError < StandardError
    attr_reader :found_page, :expected_page
    def initialize(expected_page, found_page)
      msg = "ERROR: The Application is on the wrong page!\n\tOZ expected that page to be [#{expected_page}] but found [#{found_page}]!\n"
      @found_page = found_page
      @expected_page = expected_page
      super msg
    end
  end
end