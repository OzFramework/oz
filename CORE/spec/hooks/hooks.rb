
RSpec.configure do |c|
  c.before(:each) do |example|
    create_world
    log_spec(example)
  end

  c.after(:each) do |example|
    cleanup_world
    # For Some reason rspec blows away the instance before the formatter is called, so i have to persist the logger in the example which isn't really
    # a defined rspec behavior...
    example.instance_variable_set(:@logger, example.example_group_instance.logger)
  end
end

RSpec.shared_examples 'a web page' do
  before(:each) {start_at(described_class)}
  it 'so it should load correctly' do
    correct_content?
  end
end

def log_spec(example)
  @logger.header "Spec: #{example.example_group.metadata[:location]}"
  @logger.header "ExampleLocation: #{example.metadata[:location]}".cyan
  @logger.header "Example: #{example.full_description}".cyan

  @logger.header ''
  @logger.header ''
end