
require 'Watir-webdriver'

module CoreWorld

    attr_accessor :browser, :configuration, :ledger, :router
    attr_reader :root_page, :data_target, :logger

    def create_empty_world(page_class)
        load_configuration
        colorless_output = @configuration['COLORLESS_OUTPUT'] == 'true'
        @logger = OzLogger.new(self, OzLogger.send(@configuration['LOG_LEVEL'].to_sym), colorless_output )
        log_header
        log_configuration

        load_url_data
        reset_data_target

        @ledger = Ledger.new(self)
        @root_page = page_class.new(self, root_page=true)
    end

    def set_data_target(name)
        @logger.debug("Setting data target to [#{name}]")
        @data_target = name
    end

    def reset_data_target
        target = 'DEFAULT'
        @logger.debug("Setting data target to [#{target}]")
        @data_target = target
    end

    def cleanup_world
        @browser.close if @configuration['CLOSE_BROWSER'] == 'true'
        @ledger.print_all if @configuration['PRINT_LEDGER'] == 'true'
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
                raise "ERROR: No browser specified in ./CORE/config/user_config.yml\n" if @configuration['BROWSER'].nil?
                raise "ERROR: Browser #{@configuration['BROWSER']} is not supported!\n"
        end

        @router = Router.new(self)
    end

    def create_chrome_browser
        caps = Selenium::WebDriver::Remote::Capabilities.chrome(chrome_options: {'detach' => true})

        if @configuration['USE_GRID'] == 'true'
            driver = Selenium::WebDriver.for(:remote, :url => environment['GRID'] , desired_capabilities: caps)
        else
            path = "#{Dir.pwd}/utils/web_drivers/chromedriver"
            path += '.exe' if OS.windows?
            driver = Selenium::WebDriver.for(:chrome, desired_capabilities: caps, driver_path: path)
        end
        @browser = Watir::Browser.new(driver)
    end

    def create_internet_explorer_browser
        @logger.debug 'Running internet_explorer_protected_mode.bat...'
        result = system("#{Dir.pwd}/utils/web_drivers/internet_explorer_protected_mode.bat")

        Selenium::WebDriver::IE.driver_path = "#{Dir.pwd}/utils/web_drivers/IEDriverServer.exe"
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.timeout = 120 # seconds
        driver = Selenium::WebDriver.for(:ie, :http_client => client)

        @browser = Watir::Browser.new(driver)
    end

    def create_firefox_browser
        path = "#{Dir.pwd}/utils/web_drivers/geckodriver"
        @browser = Watir::Browser.new(:firefox, driver_path: path)
    end


    ### CONFIGURATION & ENVIRONMENT ###
    ###################################

    def environment
        environment_name = @configuration['TEST_ENVIRONMENT']
        raise "ERROR: Environment [#{environment_name}] is not defined in #{@configuration['APP_NAME']}/config/environment_config.yml !
        Available options are: #{@environments.keys}\n\n" unless @environments.keys.include? environment_name
        return @environments[environment_name]
    end

    def load_configuration
        @configuration = load_data_from_yml("../#{ENV['OZ_APP_NAME']}/config/user_config.yml")
        merge_with_system_configuration
    end

    def merge_with_system_configuration
        @configuration.keys.each do |option_name|
            if ENV[option_name]
                puts "Loading value [#{ENV[option_name]}] for ENV variable [#{option_name}] from system environment."
                @configuration[option_name] = ENV[option_name]
            end
        end
        @configuration['APP_NAME'] = ENV['OZ_APP_NAME']
    end

    def load_url_data
        @environments = load_data_from_yml("../#{@configuration['APP_NAME']}/config/environment_config.yml")
    end

    ### OUTPUT  ###
    ###############

    def log_header
        @logger.header '=========================================================================='
        @logger.header '                           _____      _ _            '
        @logger.header '               \\\\ | | |   /__   \__ _| | |_   _    '
        @logger.header '               | \\\\ | |     / /\/ _` | | | | | |   '
        @logger.header '               | | \\\\ |    / / | (_| | | | |_| |   '
        @logger.header '               | | | \\\\    \/   \__,_|_|_|\__, |   '
        @logger.header '                                           |___/     '
        @logger.header ''
        @logger.header "Feature: #{@scenario.source.last.location}"
        @logger.header "Scenario: #{@scenario.name}".cyan
        @scenario.source.last.children.each do |step|
            @logger.header "\t#{step.to_sexp[2..3].join(' ')}".cyan
        end
        @logger.header '=========================================================================='
    end

    def log_configuration
        @logger.debug ''
        @logger.debug '====== Configuration ======'
        @configuration.each_pair do |key, value|
            @logger.debug "#{key}: [#{value}]"
        end
        @logger.debug '==========================='
        @logger.debug ''
    end

    def log_progress(scenario_list)
        @logger.header '================================ PROGRESS ================================'
        line = ''
        scenario_list.each do |scenario_passed|
            line += scenario_passed ? '|passed| '.green : '|failed| '.red
            if line.length >= 144
                @logger.header line
                line = ''
            end
        end
        @logger.header line
        @logger.header '=========================================================================='
        @logger.header ''
        @logger.header ''
        @logger.header ''
        @logger.header ''
    end

end

append_to_world(CoreWorld)