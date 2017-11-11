class TextFieldElement < FillableElement
    def self.type
        :text_field
    end

    def assign_element_type
        @element_type = :input
    end

    def watir_element
        @watir_element ||= browser.text_field(@locator_hash)
    end

    def value
        assert_active
        watir_element.value
    end

    def manually_clear
      watir_element.click
      browser.send_keys(:end)
      watir_element.value.size.times do
          browser.send_keys(:backspace) unless watir_element.value.chomp == ""
      end
    end

end