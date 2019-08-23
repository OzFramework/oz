require_relative 'core_world/pave_stones'

module Oz
  module CoreWorld

    attr_accessor :scenario_state, :configuration, :browser, *PaveStones.keys
    attr_reader :root_page, :data_target, :logger

    def create_world
      @configuration = PaveStones.configuration_engine.new
      @logger = PaveStones.logger.new(self)
      @data_engine = PaveStones.data_engine.new(self)
      @ledger = PaveStones.ledger.new(self)
      @router = PaveStones.router.new(self)
      @browser_engine = PaveStones.browser_engine.new(self)
      @validation_engine = PaveStones.validation_engine.new(self)
      @watir_version = Gem.loaded_specs['watir']&.version &.>= Gem::Version.create('6.12')
      @scenario_state = {}
      log_header
      set_data_target
    end

    ##
    # Add a world module to the world at runtime registering an accessor for it as well
    # Usage: register_world_module(OzFw::EmailClient)
    # @world.email_client.get_messages(10, 1)
    def register_world_module(clazz)
      self.class.instance_eval { attr_accessor clazz.world_name }
      send("#{clazz.world_name}=", clazz.new(self))
    end

    def set_root_page(page_class)
      @root_page = page_class.new(self, root_page=true)
    end

    def set_data_target(name = nil)
      name ||= 'DEFAULT'
      @logger.debug("Setting data target to [#{name}]")
      @data_target = name
    end

    def cleanup_world
      @validation_engine.cleanup
    ensure
      @browser_engine.cleanup
      @ledger.cleanup
    end

    def log_header
      @logger.header '|==================|'
      @logger.header '|    ____ ______   |'
      @logger.header '|   / __ \\___  /   |'
      @logger.header '|  | |  | | / /    |'
      @logger.header '|  | |  | |/ /     |'
      @logger.header '|  | |__| / /__    |'
      @logger.header '|   \\____/_____|   |'
      @logger.header '|                  |'
      @logger.header '|==================|'
      @logger.header ''
      @logger.debug "#{@configuration}"
    end

  end

  OzLoader.append_to_world(CoreWorld)
end