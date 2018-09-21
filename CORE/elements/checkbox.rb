class CheckboxElement < CoreElement
  def self.type
    :checkbox
  end

  def assign_element_type
    @element_type = :input
  end

  def fill(data)
    checked = data.downcase == 'checked'
    assert_active
    @world.logger.action "Filling [#{@name}] with [#{data}]"
    watir_element.set(checked)

    begin
      Watir::Wait.until(timeout: 1){watir_element.set? == checked}
    rescue
      raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.value}]"
    end
    @world.ledger.record_fill(@name, data)
    super
  end

  def watir_element
    @watir_element ||= parent.checkbox(@locator_hash)
  end

  def value
    assert_active
    watir_element.set? ? 'checked' : 'unchecked'
  end
end