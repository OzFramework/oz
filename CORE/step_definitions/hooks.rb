
$completed_scenarios = []

Before do |scenario|

  create_world

  @logger.header "Feature: #{scenario.source.last.location}"
  if scenario.source.last.class.to_s == 'Cucumber::Core::Ast::Scenario'
    @logger.header "Scenario: #{scenario.name}".cyan
    scenario.source.last.children.each do |step|
      @logger.header "\t#{step.text}".cyan
    end

  elsif scenario.source.last.class.to_s == 'Cucumber::Core::Ast::ExamplesTable::Row'
    @logger.header "Scenario Outline: #{scenario.name}".cyan
    scenario.source[1].steps.each do |step|
      @logger.header "\t#{step.text}".cyan
    end
    example_row = "\t| "
    scenario.source.last.values.each do |value|
      example_row += " #{value} |"
    end
    @logger.header "#{example_row}".cyan

  else
    @logger.warn 'WARNING: Oz could not parse scenario details'
  end

  @logger.header ''
  @logger.header ''

end


After do |scenario|

  cleanup_world

  $completed_scenarios << scenario.passed?
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