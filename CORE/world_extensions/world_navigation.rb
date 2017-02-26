
module WorldNavigation

    attr_reader :current_page

    def proceed_to(target_page)
        return if @current_page.class == target_page
        routes = @router.get_routes_between(@current_page.class, target_page)
        raise "No path found from [#{@current_page.class}] to [#{target_page}]" unless routes
        routes.each do |route|
            @current_page.navigate_via_route(route)
        end
    end

    def assert_and_set_page(page_name)
        @router.wait_for_page_to_load(page_name)
        @router.assert_application_is_on_page(page_name)
        unless @current_page.class == page_name
            @current_page = page_name.new(self)
            @ledger.save_page_visit(page_name)
            @current_page.on_page_load
        end
    end
end

append_to_world(WorldNavigation)