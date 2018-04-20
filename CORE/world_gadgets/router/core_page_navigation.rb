
class CorePage

    #TODO: This needs refactoring into a module for the router

    class << self
        attr_accessor :parent_classes
    end

    def self.inherited(subclass)
        subclass.parent_classes = [self] - [CorePage]
        subclass.parent_classes += self.parent_classes if self.parent_classes
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


    def navigate_via_route(route)
        route.prerequisites.each { |prerequisite| self.send(prerequisite) }
        action = route.action
        self.respond_to?(action) ? self.send(action) : @elements[action].click
        @world.assert_and_set_page(route.target_page)
    end

    def wait_for_page_to_load
        @world.router.wait_for_page_to_load
    end

    #This is for overriding in subclasses.
    # It will be called automatically when a page is fully loaded (once assert_and_set_page finishes).
    def on_page_load; end

end