

class ValidationPoint

  attr_reader :fail_message

  def initialize(validation_engine)
    @validation_engine = validation_engine
    @fail_message = nil
  end

  def pass
    @validation_engine.complete_validation_point(:pass)
  end

  def fail(message)
    @fail_message = message
    @validation_engine.complete_validation_point(:fail, message)
  end

end

class ValidationEngine

  def initialize(world)
    @world = world
    @validation_mode_on = false
    @current_point = nil
    @failed_points = []
    @visited_points = []
  end


  def enter_validation_mode
    @validation_mode_on = true
  end

  def exit_validation_mode
    @validation_mode_on = false
    if @failed_points.length > 0
      message = "ERROR: [#{@failed_points.length}] of [#{@visited_points.length}] validation points failed!\n"
      @world.logger.validation_fail(message)
      @failed_points.each do |point|
        @world.logger.validation_fail("#{point.fail_message}\n")
        message << point.fail_message << "\n"
      end
      raise message
    end

    if @visited_points.empty?
      raise "ERROR: Validation Mode was completed but no validation points were created."
    end

    @world.logger.debug("Validation Mode completed with #{@visited_points.length} checks.")
  end

  def add_validation_point(message)
    if @current_point != nil
      raise 'ERROR: Cannot have more than one validation point open at once.'
    end
    @world.logger.validation(message)
    @current_point = ValidationPoint.new(self)
  end

  def complete_validation_point(result, message = nil)
    @visited_points.push(@current_point)
    if result == :fail
      @world.logger.validation_fail(message)
      @failed_points.push(@current_point)
    end
    @current_point = nil
  end

  def cleanup
    @world.logger.debug('Cleaning up Validation Engine...')

    if @visited_points.empty?
      error_message = "ERROR: No validation points were created! This test didn't actually TEST anything!"
      @world.logger.validation_fail error_message
      raise error_message
    end

    @world.logger.debug("Test completed with #{@visited_points.length} validation checks.")
  end

end