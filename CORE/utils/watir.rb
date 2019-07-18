# TODO Remove this file when watir updates to 6.16.6
require 'watir'

unless Gem.loaded_specs['watir'].version >= Gem::Version.create('6.16.6')
  module Watir
    class Element
      def exists?
        if located? && stale?
          reset!
        elsif located?
          return true
        end

        assert_exists
        true
      rescue UnknownObjectException, UnknownFrameException
        false
      end

      alias exist? exists?

      def present?
        display_check
      rescue UnknownObjectException, UnknownFrameException
        false
      end

      def element_call(precondition = nil, &block)
        caller = caller_locations(1, 1)[0].label
        already_locked = Wait.timer.locked?
        Wait.timer = Wait::Timer.new(timeout: Watir.default_timeout) unless already_locked

        begin
          check_condition(precondition, caller)
          Watir.logger.debug "-> `Executing #{inspect}##{caller}`"
          yield
        rescue unknown_exception => ex
          element_call(:wait_for_exists, &block) if precondition.nil?
          msg = ex.message
          msg += '; Maybe look in an iframe?' if @query_scope.iframe.exists?
          custom_attributes = @locator.nil? ? [] : selector_builder.custom_attributes
          unless custom_attributes.empty?
            msg += "; Watir treated #{custom_attributes} as a non-HTML compliant attribute, ensure that was intended"
          end
          raise unknown_exception, msg
        rescue Selenium::WebDriver::Error::StaleElementReferenceError
          reset!
          retry
        rescue Selenium::WebDriver::Error::ElementNotInteractableError
          raise_present unless Wait.timer.remaining_time.positive?
          raise_present unless %i[wait_for_present wait_for_enabled wait_for_writable].include?(precondition)
          retry
        rescue Selenium::WebDriver::Error::ElementNotInteractableError
          raise_disabled unless Wait.timer.remaining_time.positive?
          raise_disabled unless %i[wait_for_present wait_for_enabled wait_for_writable].include?(precondition)
          retry
        rescue Selenium::WebDriver::Error::NoSuchWindowError
          raise NoMatchingWindowFoundException, 'browser window was closed'
        ensure
          Watir.logger.debug "<- `Completed #{inspect}##{caller}`"
          Wait.timer.reset! unless already_locked
        end
      end

      def display_check
        assert_exists
        @element.displayed?
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        reset!
        retry
      end

      def stale_in_context?
        @element.css_value('staleness_check') # any wire call will check for staleness
        false
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        true
      end
    end
  end
end