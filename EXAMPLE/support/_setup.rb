OZ_APP_NAME = ENV['OZ_APP_NAME'] = 'EXAMPLE'
ENV['OZ_CONFIG_DIR'] = "../#{OZ_APP_NAME}/config" if defined?(Cucumber)
ENV['OZ_CONFIG_DIR'] = "config" if defined?(RSpec::ExampleGroups)

require_relative '../../CORE/setup.rb'

require_all("../#{OZ_APP_NAME}/overrides/elements") unless defined?(Cucumber)
require_all("../#{OZ_APP_NAME}/data_models") unless defined?(Cucumber)

require_relative '../pages/example_storefront_root_page.rb'
recursively_require_all_base_pages("../#{OZ_APP_NAME}/pages")
recursively_require_all_edge_pages("../#{OZ_APP_NAME}/pages")

require_all("../#{OZ_APP_NAME}/step_definitions") if defined?(Cucumber)
require_all("../#{OZ_APP_NAME}/spec/helpers") if defined?(RSpec::ExampleGroups)
require_all("../#{OZ_APP_NAME}/spec/hooks") if defined?(RSpec::ExampleGroups)

