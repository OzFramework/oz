
class SelectListElement < CoreElement

  # In the example website select lists have styling that sets their opacity to 0.
  # Because of this we can't reliably use visibility checks as they are designed.
  # To counteract this we will augment the behavior of the visible? method.
  def present?
    begin
      return watir_element.exists?
    rescue Watir::Exception::UnknownObjectException => e
      @world.logger.warn 'Object not found during visibility check, proceeding anyway...'
      return false
    end
  end


  # For some reason even though watir can find and interact with these elements it times out trying to call
  # `select` on them. As a workaround we are using send text instead. This is not really a problem because
  # we are checking the content after the fill happens to make sure the content is what we expect/want.
  def fill(data)
    assert_active
    @world.logger.action "Filling [#{@name}] with [#{data}]"
    watir_element.send_keys(data)

    begin
      Watir::Wait.until(timeout: 1){watir_element.text == data}
    rescue
      raise "ERROR: Problem filling element [#{@name}] with [#{data}] value after fill was found as [#{watir_element.text}]"
    end
    @world.ledger.record_fill(@name, data)
    super
  end

end