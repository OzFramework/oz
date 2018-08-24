class RadioButtonElement < CoreElement
  def self.type
    :radio_button
  end

  def assign_element_type
    @element_type = :input
  end

  def fill(data)
    assert_active
    @world.logger.action "Selecting [#{@name}]"
    if data == 'selected'
      watir_element.set
      begin
        Watir::Wait.until(timeout: 1){value}
      rescue
        raise "ERROR: Problem selecting element [#{@name}] value found after fill was [#{value}]"
      end
    end
    @world.ledger.record_fill(@name, data)
    super
  end

  def value
    assert_active
    watir_element.set? ? 'selected' : 'unselected'
  end

  def watir_element
    @watir_element ||= parent.radio(@locator_hash)
  end
end