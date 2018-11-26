module Oz
  module PageHelper
    def start_at(target_page, from_page: nil)
      @root_page.begin_new_session
      navigate_to(target_page, from_page: from_page)
    end

    def navigate_to(target_page, from_page: nil)
      from_page = CoreUtils.find_class(from_page&.gsub(' ', '::') + ' Page') if from_page&.is_a?(Class)
      target_page = CoreUtils.find_class(target_page.gsub(' ', '::') + ' Page') unless target_page.is_a? Class
      proceed_to(from_page) if from_page
      proceed_to(target_page)
      set_data_target
    end

    def fill_with(data_name)
      @current_page.fill data_name
    end

    def click_on(element_name)
      @current_page.click_on(element_name.to_ruby_symbol)
    end

    def hover_over(element_name)
      @current_page.hover_over(element_name.to_ruby_symbol)
    end
  end
end

append_to_world(Oz::PageHelper)