$completed_scenarios = []

class StatusFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_pending, :example_failed

  def initialize(*args)
  end

  def example_finished(notification)
    example = notification.example
    # For Some reason rspec blows away the instance before this point, so i have to persist the logger in the example which isn't really
    # a defined rspec behavior...
    @logger = example.instance_variable_get(:@logger)

    $completed_scenarios << example.execution_result.status
    @logger.header '================================ PROGRESS ================================'
    line = ''
    $completed_scenarios.each do |scenario_passed|
      line += scenario_passed ? '|passed| '.green : '|failed| '.red
      if line.length >= 144
        @logger.header line
        line = ''
      end
    end
    @logger.header line
    @logger.header '=========================================================================='
    @logger.header ''
  end
  alias example_passed example_finished
  alias example_pending example_finished
  alias example_failed example_finished
end

RSpec.configure do |c|
  c.add_formatter StatusFormatter
end