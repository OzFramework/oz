class IFrameElement < CoreElement
  def self.type
    :iframe
  end

  def assign_element_type
    @element_type = :iframe
  end

  def watir_element
    @watir_element ||= parent.iframe(@locator_hash)
  end

end