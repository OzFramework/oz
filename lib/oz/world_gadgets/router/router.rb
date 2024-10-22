require_relative 'router_store'
require_relative 'routing_path'

module Oz
  class Router

    def initialize(world)
      @world = world
      @registry = RouterStore.registry
      @page_blueprints = RouterStore.generate_graph(@world)
      create_dot_file_from_graph if @world.configuration['CREATE_DOT_GRAPH']
    end

    def page_class_for(target_page)
      @registry.find{|it| it.to_s.downcase.eql? target_page.downcase.delete(' ')}
    end

    def wait_for_page_to_load(target_page = @world.current_page.class)
      @world.logger.debug "Waiting on [#{target_page}] to load..."
      timeout = 20
      timeout = 60 if @world.configuration["BROWSER"] == "internet_explorer"

      start_time = Time.now()
      CoreUtils.wait_until(timeout) { blueprint(target_page).done_waiting? }
      @world.logger.debug "Page loaded after [#{(Time.now - start_time).round(0)}] seconds"
    end

    def application_is_on_page?(page_class)
      @world.logger.debug "Attempting to ID page [#{page_class}]"
      blueprint(page_class).id_page
    end

    def find_current_page
      @page_blueprints.keys.each do |page_class|
        return page_class if application_is_on_page?(page_class)
      end
      return "Could not find current page!"
    end

    def assert_application_is_on_page(page_class)
      @world.logger.debug "Ensuring that application is on page [#{page_class}]"

      unless CoreUtils.wait_until(3){application_is_on_page?(page_class)}
        @world.logger.debug "Application was not on the [#{page_class}], attempting to find current page"
        current_page = find_current_page
        raise OzFramework::WrongPageError.new(page_class, current_page)
      end
    end

    def get_routes_between(start_page, destination_page, visited_page_paths = { start_page => [] }, open_pages = [])
      @world.logger.debug "Searching for path from [#{start_page}] to [#{destination_page}]..."
      current_path = visited_page_paths[start_page]
      start_blueprint = blueprint(start_page)
      next_pages = start_blueprint.connected_pages - visited_page_paths.keys

      next_pages.each do |page|
        route = start_blueprint.get_route_to(page)
        combined_path = current_path + [ route ]

        return RoutingPath.new(combined_path, self, @world) if destination_page == page

        visited_page_paths[page] = combined_path
        open_pages.push(page)
      end

      return nil if open_pages.empty?
      return get_routes_between(open_pages[0], destination_page, visited_page_paths, open_pages[1..-1])
    end

    def create_dot_file_from_graph
      @world.logger.debug "Writing graph to page_graph.dot..."

      graph_file = File.open("page_graph.dot", "w")
      graph_file.write "digraph G {"
      @page_blueprints.each_pair do |start_page, blueprint|
        blueprint.routes.each_pair do |action, route|
          graph_file.write "#{start_page} -> #{route.target_page}[color=\"green\", label=\"#{route.action}\"];\n" unless route.target_page == start_page
        end
      end
      graph_file.write "}"
      graph_file.close

      @world.logger.debug "Done!"
    end

    def blueprint(name)
      @page_blueprints[name] || raise(Oz::NoPageInRegistryError.new(name))
    end

  end
end