

ENV['OZ_APP_NAME'] = 'EXAMPLE'
ENV['OZ_CONFIG_DIR'] = "#{File.dirname(__FILE__)}/config"

require_relative '../CORE/setup.rb'

require_all('../EXAMPLE/overrides/elements')

require_relative '../EXAMPLE/pages/example_storefront_root_page.rb'
recursively_require_all_base_pages('../EXAMPLE/pages')
recursively_require_all_edge_pages('../EXAMPLE/pages')

require_all('../EXAMPLE/step_definitions') if defined?(Cucumber)