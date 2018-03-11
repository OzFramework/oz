class RadioButtonElement < CoreElement
  def self.type
    :radio_button
  end

  def assign_element_type
    @element_type = :input
  end

  def fill(data)
    assert_active
    @world.logger.action "Filling [#{@name}] with [#{data}]"
    watir_element.set(data == 'true' ? true : false)

    begin
      Watir::Wait.until(timeout: 1){watir_element.set? == data}
    rescue
      raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.set?}]"
    end
    @world.ledger.record_fill(@name, data)
    super
  end

  def value
    assert_active
    watir_element.set? ? 'true' : 'false'
  end

  def watir_element
    puts @locator_hash
    @watir_element ||= browser.radio(@locator_hash)
  end
end