require_relative '../../world_gadgets/configuration_engine'
require_relative '../../world_gadgets/oz_logger'
require_relative '../../world_gadgets/ledger'
require_relative '../../world_gadgets/validation_engine'
require_relative '../../world_gadgets/router/router'
require_relative '../../world_gadgets/browser_engine'
require_relative '../../world_gadgets/data_engine'

# Allows overriding of the classes used by CoreWorld to create its submodules.
# Usage looks like
# CoreWorld::PaveStones.logger = MyShinyNewLogger
# Aliased to CoreWorld::Settings
#
module CoreWorld
  module PaveStones
    @settings = {
      configuration_engine: ConfigurationEngine,
      logger: OzLogger,
      ledger: Ledger,
      validation_engine: ValidationEngine,
      router: Router,
      browser_engine: BrowserEngine,
      data_engine: DataEngine
    }
    class << self
      extend Enumerable

      def configs
        @settings
      end

      def keys
        @settings.keys.reject{ |key, _| key == :logger } #logger is defined as readonly in CoreWorld once initialized, preserving this.
      end

      def [](arg)
        @settings[arg]
      end

      def []=(arg, value)
        @settings[arg] = value
      end

      def each
        @settings.each
      end

      def respond_to_missing?
        true
      end

      def method_missing(method, *args)
        super unless @settings.keys.include? method
        @settings[method]
      end

    end
  end
end

CoreWorld::Settings = CoreWorld::PaveStones
