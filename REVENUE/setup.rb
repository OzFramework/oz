ENV['OZ_APP_NAME'] = 'REVENUE'
ENV['OZ_CONFIG_DIR'] = "#{File.dirname(__FILE__)}/config"

require_relative '../CORE/setup.rb'

require_all('../REVENUE/overrides/elements')
require_all('../REVENUE/data_models')

require_relative '../REVENUE/pages/example_storefront_root_page.rb'
recursively_require_all_base_pages('../REVENUE/pages')
recursively_require_all_edge_pages('../REVENUE/pages')

require_all('../REVENUE/step_definitions') if defined?(Cucumber)