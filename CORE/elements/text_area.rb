class TextAreaElement < CoreElement
    def self.type
        :text_area
    end

    def assign_element_type
        @element_type = :textarea
    end

    def watir_element
        @watir_element ||= parent.textarea(@locator_hash)
    end

    def value
        assert_active
        watir_element.value
    end

    def fill(data)
      assert_active
      @world.logger.action "Filling [#{@name}] with [#{data}]"
      watir_element.set(data)

      begin
        Watir::Wait.until(timeout: 1){watir_element.value == data}
      rescue
        raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.value}]"
      end
      @world.ledger.record_fill(@name, data)
      super
    end

end