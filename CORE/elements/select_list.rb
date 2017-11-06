class SelectListElement < FillableElement
  def self.type
    :select_list
  end

  def assign_element_type
    @element_type = :input
  end

  def fill(data)
    assert_active
    @world.logger.action "Filling [#{@name}] with [#{data}]"
    # manually_clear if @world.configuration["BROWSER"] == "internet_explorer"
    watir_element.select(data)

    begin
      Watir::Wait.until(1){watir_element.text == data}
    rescue
      raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.value}]"
    end
    @world.ledger.record_fill(@name, data)
  end

  def watir_element
    @watir_element ||= browser.select(@locator_hash)
  end
end