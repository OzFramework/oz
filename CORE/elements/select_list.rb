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
    @watir_element ||= browser.select(@locator_hash)
  end

  def validate(data)
    super(data)
    if @options.has_key?(:options)
      validation_point = @world.validation_engine.add_validation_point("Checking that [#{@name}] has options [#{@options[:options]}]...")
      select_options = watir_element.html.scan(/<option[^>]*?>(.*?)<\/option>/i).flatten
      complete_match = true
      @options[:options].each do |option|
        unless select_options.include?(option)
          complete_match = false
        end
      end
      select_options.each do |option|
        unless @options[:options].include?(option)
          complete_match = false
        end
      end
      if complete_match
        validation_point.pass
      else
        validation_point.fail("ERROR! [#{@name}] has incorrect options!\n\tFOUND: #{select_options}\n\tEXPECTED: #{@options[:options]}")
      end
    end
  end

end