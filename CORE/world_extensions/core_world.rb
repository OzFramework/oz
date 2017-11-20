
require 'watir-webdriver'

module CoreWorld

    attr_accessor :browser, :configuration, :ledger, :router, :data_engine, :browser_engine
    attr_reader :root_page, :data_target, :logger

    def create_world
        @configuration = ConfigurationEngine.new
        @logger = OzLogger.new(self)
        @data_engine = DataEngine.new(@logger)
        @ledger = Ledger.new(self)
        @router = Router.new(self)
        @browser_engine = BrowserEngine.new(self)
        log_header
        set_data_target
    end

    def set_root_page(page_class)
        @root_page = page_class.new(self, root_page=true)
    end

    def set_data_target(name='DEFAULT')
        @logger.debug("Setting data target to [#{name}]")
        @data_target = name
    end

    def cleanup_world
        @browser.close if @configuration['CLOSE_BROWSER']
        @ledger.print_all if @configuration['PRINT_LEDGER']
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

append_to_world(CoreWorld)
