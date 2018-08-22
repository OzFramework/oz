class IFrameElement < CoreElement
  def self.type
    :iframe
  end

  def assign_element_type
    @element_type = :iframe
  end

  def watir_element
    @watir_element ||= browser.iframe(@locator_hash)
  end

end