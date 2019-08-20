class CoreElement;
end
OzLoader.require_all('./elements')

class CoreElement

  @locator_options = %i[id class xpath text href for name css index]
  class << self
    ## Allows setting a custom list of locator options
    attr_accessor :locator_options
  end

  def self.type
    :core_element
  end

  attr_reader :name, :active, :locator_hash, :parent

  ### Attrib Methods ###

  def initialize(name, world, options)
    @name = name + type
    @locator_hash = options.select { |locator_type, _| @locator_options.include? locator_type }
                           .map { |locator_type, value| [locator_type, value] }
                           .to_h
    ensure_valid_selector
    @world = world
    @active = @options[:active] || true
    @clear = @options[:clear] || false
    @parent = @options[:parent] || browser
    @on_fill = @on_click = @on_hover = Proc.new

    assign_element_type
  end

  def ensure_valid_selector
    raise OzFramework::InvalidElementSelectorError.new(@name, @locator_hash, @locator_options) if @locator_hash.empty?
  end

  def type
    self.class.type
  end

  def browser
    @world.browser
  end

  def watir_element
    @watir_element ||= parent.send(@element_type, @locator_hash)
  end

  def assign_element_type
    @element_type = @options[:element_type] || :div
  end

  ### Behavioral Methods ###

  def click
    assert_active
    @world.logger.action "Clicking [#{@name}]"
    try_click
    @on_click.call
  end

  def try_click
    watir_element.click
  rescue Selenium::WebDriver::Error::UnknownError => error
    raise error unless error.message =~ /Element is not clickable at point .* Other element would receive the click/

    @world.logger.warn 'Click failed, assuming it was due to animations on the page. Trying again...'
    raise "Click kept failing! Original Error: \n#{error}" unless CoreUtils.wait_safely(3) { watir_element.click }
  end

  def on_click(&block)
    @on_click = block
  end

  def hover
    assert_active
    @world.logger.action "Hovering over [#{@name}]"
    success = try_hover
    @on_hover.call if success
  end

  def try_hover
    watir_element.hover
  rescue Watir::Exception::UnknownObjectException => _error
    @world.logger.warn 'Unable to hover over element, attempting to proceed anyway...'
    false
  end

  def on_hover(&block)
    @on_hover = block
  end

  def fill(_data)
    @on_fill.call
  end

  def on_fill(&block)
    @on_fill = block
  end

  def visible?
    @world.logger.warn '[OZ DEPRECATION] Checking `#visisble?` is deprecated. Use `#present?` instead.'
    present?
  end

  def present?
    watir_element.present?
  end

  def flash
    return unless @world.configuration['FLASH_VALIDATION']
    assert_active
    watir_element.flash
  end

  def value
    assert_active
    return nil unless present?
    watir_element.text
  end

  def attribute_value(attribute_name)
    watir_element.attribute_value(attribute_name)
  end

  def assert_active
    raise "ERROR: Element [#{@name}] being accessed when not active!!\n" unless @active
  end

  def activate
    @active = true
  end

  def deactivate
    @active = false
  end

  def active?
    @active
  end
  
  def activate_if(condition)
    condition ? activate : deactivate
  end

  # TODO refactor when validator logic gets merged in.
  def validate(_data)
    status = active ? 'is' : 'is not'
    validation_point = @world.validation_engine.add_validation_point("Checking that [#{@name}] #{status} displayed...")
    if active == present?
      validation_point.pass
      flash if active
    elsif !active && present?
      validation_point.fail("  [#{@name}] was found on the page!\n       FOUND: #{@name}\n    EXPECTED: Element should not be displayed!")
    else
      validation_point.fail("  [#{@name}] was not found on the page!\n       FOUND: None\n    EXPECTED: #{@name} should be displayed!")
    end
  end

end
