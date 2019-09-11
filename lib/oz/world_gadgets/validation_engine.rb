require_relative '../errors/not_in_validation_mode_error'

module Oz

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

    ##
    # Execute a group of validations
    def perform_validations
      enter_validation_mode
      yield
      exit_validation_mode
    end

    ##
    # Performs a singular validation, validation mode must have been activated
    # externally, such as with element validations or through a
    # perform_validations block.  Yields the created validation point to the
    # block.
    #
    # Use:
    # @world.validation_engine.validate('one plus one equals 2', 'failed to calculate 2 from 1 plus 1') do
    #   1+1=3
    # end
    #
    # @world.validaiton_engine.validate('It did the thing', 'failed normally') do |validation_point|
    #   validation_point.fail('Oh noes.') if some_obscure_edge_case
    #   do_the_thing
    # end
    # @param [String] message
    # @param [String] fail_message
    def validate(message, fail_message)
      raise(Oz::NotInValidationModeError.new) unless @validation_mode_on
      validation_point = add_validation_point(message)
      result = yield(validation_point)
      if result
        validation_point.pass
      else
        validation_point.fail(fail_message)
      end
    end

    ##
    # Sets validation mode, executes a single validation and then exits immediately.
    # Use:
    # @world.validation_engine.validate('one plus one equals 2', 'failed to calculate 2 from 1 plus 1') do
    #   1+1=3
    # end
    # @param [String] message
    # @param [String] fail_message
    def validate!(message, fail_message)
      enter_validation_mode
      validate(message, fail_message) { yield }
      exit_validation_mode
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
end