class SelectListElement < CoreElement
  def self.type
    :select_list
  end

  def assign_element_type
    @element_type = :input
  end

  def fill(data)
    assert_active
    @world.logger.action "Filling [#{@name}] with [#{data}]"
    watir_element.select(data)

    begin
      Watir::Wait.until(timeout: 1){watir_element.text == data}
    rescue
      raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.text}]"
    end
    @world.ledger.record_fill(@name, data)
    super
  end

  def watir_element
    @watir_element ||= parent.select(@locator_hash)
  end
end