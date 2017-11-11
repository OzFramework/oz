class ElementGroup

  def initialize(*elements)
    @elements = [elements].flatten
    @active = true
  end

  def deactivate
    @elements.each do |element|
      element.deactivate
    end
    @active = false
    self
  end

  def activate
    @elements.each do |element|
      element.activate
    end
    @active = true
    self
  end

  def active?
    @active
  end

  def fill

  end

end