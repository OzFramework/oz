
module Oz
  class CorePage

    #TODO: This needs refactoring into a module for the router

    class << self
      attr_accessor :parent_classes
    end

    def self.inherited(subclass)
      subclass.parent_classes = [self] - [CorePage]
      subclass.parent_classes += self.parent_classes if self.parent_classes
      RouterStore.registry << subclass
      RouterStore.store_page_blueprint(subclass, subclass.parent_classes)
      super
    end

    def self.add_route(page_class_symbol, action, prerequisites=[])
      RouterStore.store_route(self, page_class_symbol, action, prerequisites)
    end

    def self.add_id_element(element_type, value, id_hash)
      RouterStore.store_id_element(self, element_type, id_hash, value)
    end

    def self.add_wait_element(element_type, action = :wait_until_present, id_hash)
      RouterStore.store_wait_element(self, element_type, id_hash, action)
    end


    # Todo Pull this into router since it's not strictly speaking something that the page should be handling.
    # =======================================================================================================
    def navigate_via_route(route)
      route.prerequisites.each do |prerequisite|
        self.send(prerequisite) unless prerequisite.is_a? Array
        self.send(prerequisite[0], prerequisite[1]) if prerequisite.is_a? Array
      end
      action = route.action
      if action.is_a? Array
        self.send(action[0], *action[1..-1])
      else
        self.respond_to?(action) ? self.send(action) : @elements[action].click
      end
      @world.assert_and_set_page(route.target_page)
    end

    # Check if a page was a valid target from this page.
    def valid_route_target?(page)
      @world.router.get_routes_between(self.class, page).any?
    end

    def wait_for_page_to_load
      @world.router.wait_for_page_to_load
    end

    # =======================================================================================================

    #This is for overriding in subclasses.
    # It will be called automatically when a page is fully loaded (once assert_and_set_page finishes).
    def on_page_load; end

  end
end