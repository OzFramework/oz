module Oz
  class CheckboxElement < CoreElement

    # In the example website checkboxes have styling that sets their opacity to 0.
    # Because of this we can't reliably use visibility checks as they are designed.
    # To counteract this we will augment the behavior of the visible? method.
    def present?
      begin
        return watir_element.exists?
      rescue Watir::Exception::UnknownObjectException => e
        @world.logger.warn 'Object not found during visibility check, proceeding anyway...'
        return false
      end
    end

  end
end