module Oz
  module Router
    class RoutingPath
      include Enumerable
      attr_reader :routes, :router, :world

      def initialize(routes, router, world)
        @routes = routes
        @router = router
        @world = world
      end

      def insert_page(page)
        insert_page_after(@world.current_page.class, page)
      end

      def insert_page_after(starting_page, target_page)
        starting_page = @router.page_class_for(starting_page) if(target_page.is_a?(String) || target_page.is_a?(Symbol))
        target_page = @router.page_class_for(target_page) if(target_page.is_a?(String) || target_page.is_a?(Symbol))
        start_blueprint = @router.blueprint(starting_page)
        route = start_blueprint.get_route_to(target_page)
        position = @routes.index { |route| route.target_page == starting_page }
        old_route = @routes[position + 1]
        @routes.insert(position + 1, route)
        if old_route
          new_blueprint = @router.blueprint(target_page)
          new_route = new_blueprint.get_route_to(old_route.target_page)
          @routes[position + 2] = new_route
        end
      end

      # Delegate enumeration to routes
      def each(*args)
        routes.each(*args)
      end

      def run!
        @routes.each do |route|
          world.current_page.navigate_via_route(route)
        end
      end
    end
  end
end
