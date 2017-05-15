
$completed_scenarios = []

Before do |scenario|

  create_world

  @logger.header "Feature: #{scenario.source.last.location}"
  @logger.header "Scenario: #{scenario.name}".cyan
  scenario.source.last.children.each do |step|
    @logger.header "\t#{step.to_sexp[2..3].join(' ')}".cyan
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