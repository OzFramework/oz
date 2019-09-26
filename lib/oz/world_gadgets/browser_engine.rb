require 'watir'

module Oz
  class BrowserEngine

    def initialize(world)
      @world = world
    end

    def create_new_browser
      configuration = @world.configuration
      @world.logger.debug "Creating new #{configuration['BROWSER']} Browser"
      browser_type = configuration['BROWSER']
      raise "ERROR: No browser specified in configuration!\n" if browser_type.nil?
      begin
        @world.browser = send("#{browser_type}_browser")
      rescue NoMethodError => e
        raise "ERROR: Browser #{browser_type} is not supported!\n"
      end
      maximize if configuration['MAXIMIZE_BROWSER']
      resize if configuration['RESIZE_BROWSER']
      set_default_timeout
      @world.browser # Return the browser just so we're returning something.
    end

    def chrome_browser
      @read_timeouts = 0
      caps = { open_timeout: 600, read_timeout: 600, "goog:chromeOptions": {} }
      if @world.configuration['USE_GRID']
        test_name = ""
        record_video = @world.configuration['ENVIRONMENT'] == 'production' ? false : @world.configuration['RECORD_VIDEO']
        caps = { url: @world.configuration.tooling[:grid][:url],
                 "goog:chromeOptions": { detach: true },
                 recordVideo: record_video,
                 tz: 'America/New_York',
                 name: test_name,
                 build: ENV['PIPELINE_ID'] || "#{ENV['USER']}@#{ENV['HOSTNAME']}",
                 idleTimeout: 300 }
        @read_timeouts = 0
      else
        caps[:headless] = true if @world.configuration['HEADLESS_CHROME']
        caps[:"goog:chromeOptions"][:detach] = true unless caps[:headless]
        driver_path = @world.configuration['DRIVER_LOCATION']
        driver_path ||= "#{__dir__}/../utils/web_drivers/linux-chromedriver" if OS.linux?
        driver_path ||= "#{__dir__}/../utils/web_drivers/chromedriver"
        driver_path << '.exe' if OS.windows?
        Selenium::WebDriver::Chrome::Service.driver_path = driver_path
      end
      begin
        Watir::Browser.new(:chrome, caps)
      rescue Net::ReadTimeout => e
        @read_timeouts += 1
        @world.logger.warn("Error during driver creation. Trying to create the driver for the #{@read_timeouts.ordinalize} time...")
        sleep(rand(10))
        @read_timeouts <= 10 ? retry : Metadata.instance.append({exception: "#{e.backtrace.join("\n")}"})
      end
    end

    def internet_explorer_browser
      @world.logger.debug 'Running internet_explorer_protected_mode.bat...'
      system("#{@world.configuration['CORE_DIR']}/utils/web_drivers/internet_explorer_protected_mode.bat")

      Selenium::WebDriver::IE.driver_path = "#{@world.configuration['CORE_DIR']}/utils/web_drivers/IEDriverServer.exe"
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.timeout = 120 # seconds
      driver = Selenium::WebDriver.for(:ie, :http_client => client)

      return Watir::Browser.new(driver)
    end

    def set_default_timeout
      Watir.default_timeout = @world.configuration['DEFAULT_ELEMENT_TIMEOUT']
    end

    def firefox_browser
      path = "#{@world.configuration['CORE_DIR']}/utils/web_drivers/geckodriver"
      return Watir::Browser.new(:firefox, driver_path: path)
    end

    def maximize
      @world.browser.window.maximize
    end

    def resize
      width, height = @world.configuration['RESIZE_BROWSER']
      @world.browser.window.resize_to(width, height)
    rescue => error
      @world.logger.warn("WARNING: Could not resize the browser, make sure RESIZE_BROWSER option is set as an array with [width] set to first element and [height] set to second element. \n\tFull Error text: #{error.message}")
    end

    def cleanup
      @world.browser.close if @world.configuration['CLOSE_BROWSER'] and @world.browser
    end

  end
end