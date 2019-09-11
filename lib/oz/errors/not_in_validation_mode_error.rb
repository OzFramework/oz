module Oz
  ##
  # Error that raises when you attempt to call validation_engine.validate() outside of a
  # validation_engine.perform_validations block
  class NotInValidationModeError < StandardError
    def initialize
      msg = 'Attempted to call validation_engine.validate outside of a validation_engine.perform_validations block. Please use validation_engine.validate!() for one off validations.'
      super(msg)
    end
  end
end