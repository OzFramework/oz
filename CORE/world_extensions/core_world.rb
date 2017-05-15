
require 'Watir-webdriver'

module CoreWorld

    attr_accessor :browser, :configuration, :ledger, :router
    attr_reader :root_page, :data_target, :logger

    def create_world
        @configuration = ConfigurationEngine.new
        @logger = OzLogger.new(self)
        @ledger = Ledger.new(self)
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


    ### BROWSER INTERACTION ###
    ###########################

    def create_new_browser
        @logger.debug "Creating new #{@configuration['BROWSER']} Browser"
        case @configuration['BROWSER']
            when 'firefox'
                create_firefox_browser
            when 'internet_explorer'
                create_internet_explorer_browser
            when 'chrome'
                create_chrome_browser
            else
                raise "ERROR: No browser specified in configuration!\n" if @configuration['BROWSER'].nil?
                raise "ERROR: Browser #{@configuration['BROWSER']} is not supported!\n"
        end

        @router = Router.new(self)
    end

    def create_chrome_browser
        caps = Selenium::WebDriver::Remote::Capabilities.chrome(chrome_options: {'detach' => true})

        if @configuration['USE_GRID']
            driver = Selenium::WebDriver.for(:remote, :url => @configuration['ENVIRONMENT']['GRID'] , desired_capabilities: caps)
        else
            path = "#{@configuration['CORE_DIR']}/utils/web_drivers/chromedriver"
            path += '.exe' if OS.windows?
            driver = Selenium::WebDriver.for(:chrome, desired_capabilities: caps, driver_path: path)
        end
        @browser = Watir::Browser.new(driver)
    end

    def create_internet_explorer_browser
        @logger.debug 'Running internet_explorer_protected_mode.bat...'
        result = system("#{@configuration['CORE_DIR']}/utils/web_drivers/internet_explorer_protected_mode.bat")

        Selenium::WebDriver::IE.driver_path = "#{@configuration['CORE_DIR']}/utils/web_drivers/IEDriverServer.exe"
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 120 # seconds
        driver = Selenium::WebDriver.for(:ie, :http_client => client)

        @browser = Watir::Browser.new(driver)
    end

    def create_firefox_browser
        path = "#{@configuration['CORE_DIR']}/utils/web_drivers/geckodriver"
        @browser = Watir::Browser.new(:firefox, driver_path: path)
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