class CoreElement;
end
require_all('./elements')

class CoreElement
  def self.type
    :core_element
  end

  @@locator_options = [:id, :class, :xpath, :text, :href, :for, :name]

  def self.locator_options
    @@locator_options
  end

  attr_reader :name, :active, :locator_hash, :type


  ### Attrib Methods ###

  def initialize(name, world, options)
    @type = self.class.type
    @name = name + self.class.type

    has_locator = false
    @@locator_options.each do |locator_type|
      if options[locator_type]
        @locator_hash = {locator_type => options[locator_type]}
        has_locator = true
      end
    end
    raise "ELEMENT [#{name}] must have a locator!/nValid locators are: #{@@locator_options}" unless has_locator

    @world = world
    @options = {:active => true}.merge(options)
    @active = @options[:active]

    assign_element_type
  end

  def browser
    @world.browser
  end

  def parent
    @options[:parent] ? @options[:parent].watir_element : browser
  end

  def watir_element
    @watir_element ||= parent.send(@element_type, @locator_hash)
  end

  def assign_element_type
    @element_type = @options[:element_type] ? @options[:element_type] : :div
  end

  ### Behavioral Methods ###

  def click
    assert_active
    @world.logger.action "Clicking [#{@name}]"
    begin
      watir_element.click
    rescue Selenium::WebDriver::Error::UnknownError => e
      raise e unless e.message =~ /Element is not clickable at point .* Other element would receive the click/
      @world.logger.warn 'Click failed, assuming it was due to animations on the page. Trying again...'
      raise "Click kept failing! Original Error: \n#{e}" unless CoreUtils.wait_safely(3){ watir_element.click }
    end
    @on_click.call if @on_click
  end

  def on_click(&block)
    @on_click = block
  end

  def hover
    assert_active
    @world.logger.action "Hovering over [#{@name}]"
    begin
      watir_element.hover
    rescue Watir::Exception::UnknownObjectException => e
      @world.logger.warn 'Unable to hover over element, attempting to proceed anyway...'
      return false
    end
    @on_hover.call if @on_hover
  end

  def on_hover(&block)
    @on_hover = block
  end

  def fill(data)
    @on_fill.call if @on_fill
  end

  def on_fill(&block)
    @on_fill = block
  end

  def visible?
    @world.logger.warn '[OZ DEPRECATION] Checking `#visisble?` is deprecated. Use `#present?` instead.'
    present?
  end

  def present?
    begin
      watir_element.wait_until_present(timeout:0)
      return true
    rescue Watir::Wait::TimeoutError => e
      return false
    end
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

  def validate(data)
    if active
      validation_point = @world.validation_engine.add_validation_point("Checking that [#{@name}] is displayed...")
      if present?
        validation_point.pass
        flash
      else
        validation_point.fail("ERROR! [#{@name}] was not found on the page!\n\tFOUND: None\n\tEXPECTED: #{@name} should be displayed!")
      end
    else
      validation_point = @world.validation_engine.add_validation_point("Checking that [#{@name}] is not displayed...")
      if present?
        validation_point.fail("ERROR! [#{@name}] was found on the page!\n\tFOUND: #{@name}\n\tEXPECTED: Element should not be displayed!")
      else
        validation_point.pass
      end
    end
  end

end
