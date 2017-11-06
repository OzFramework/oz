class FillableElement < CoreElement
  def self.type
    :fillable_element
  end

  def fill(data)
    assert_active
    @world.logger.action "Filling [#{@name}] with [#{data}]"
    manually_clear if @world.configuration["BROWSER"] == "internet_explorer"
    watir_element.set(data)

    begin
      Watir::Wait.until(1){watir_element.value == data}
    rescue
      raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.value}]"
    end
    @world.ledger.record_fill(@name, data)
  end

  def value
    assert_active
    watir_element.value
  end
end