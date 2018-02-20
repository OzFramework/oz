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
  end

  def activate
    @elements.each do |element|
      element.activate
    end
    @active = true
  end
  
  def activate_if(condition)
    condition ? activate : deactivate
  end

  def active?
    @active
  end
  
end
