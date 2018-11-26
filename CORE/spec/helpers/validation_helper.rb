module Oz
  module ValidationHelper
    def correct_content?
      @current_page.validate_content
    end

    def on_page?(page)
      page = CoreUtils.find_class(page+' Page') unless page.is_a? Class
      validate_application_is_on_page(page)
    end
  end
end

append_to_world(Oz::ValidationHelper)