class TextFieldElement < CoreElement
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

    def fill(data)
      assert_active
      @world.logger.action "Filling [#{@name}] with [#{data}]"
      manually_clear if @world.configuration["BROWSER"] == "internet_explorer"
      watir_element.set(data)

      begin
        Watir::Wait.until(timeout: 1){watir_element.value == data}
      rescue
        raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.value}]"
      end
      @world.ledger.record_fill(@name, data)
      super
    end

    def manually_clear
      watir_element.click
      browser.send_keys(:end)
      watir_element.value.size.times do
          browser.send_keys(:backspace) unless watir_element.value == ""
      end
    end

end