
$completed_scenarios = []

Before do |scenario|
  @scenario = scenario
end

After do |scenario|
  cleanup_world
  $completed_scenarios << scenario.passed?
  log_progress($completed_scenarios)
end