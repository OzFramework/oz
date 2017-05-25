
require 'Watir-webdriver'

module CoreWorld

    attr_accessor :browser, :configuration, :ledger, :router, :data_engine
    attr_reader :root_page, :data_target, :logger

    def create_empty_world(page_class)
        @configuration = ConfigurationEngine.new
        colorless_output = true if @configuration['COLORLESS_OUTPUT']
        @logger = OzLogger.new(self, OzLogger.send(@configuration['LOG_LEVEL'].to_sym), colorless_output )
        log_header
        log_configuration
        reset_data_target

        @data_engine = DataEngine.new(@logger)
        @ledger = Ledger.new(self)
        @router = Router.new(self)
        @browser_engine = BrowserEngine.new(self)
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
        @browser.close if @configuration['CLOSE_BROWSER']
        @ledger.print_all if @configuration['PRINT_LEDGER']
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
        @logger.debug "#{@configuration}"
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