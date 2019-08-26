ENV['OZ_APP_NAME'] = 'EXAMPLE'
ENV['OZ_CONFIG_DIR'] = "#{File.dirname(__FILE__)}/config"

require_relative '../lib/oz/setup.rb'

require_relative '../lib/oz/step_definitions'

require_all('./overrides/elements')
require_all('./data_models')

require_relative 'pages/example_storefront_root_page.rb'
recursively_require_all_base_pages('./pages')
recursively_require_all_edge_pages('./pages')

require_all('./step_definitions') if defined?(Cucumber)