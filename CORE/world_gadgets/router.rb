
class RouterStore

  class << self
    attr_accessor :stored_specs, :stored_routes, :stored_elements
  end

  def self.stored_specs
    @@stored_specs
  end

  def self.stored_routes
    @@stored_routes
  end

  def self.stored_elements
    @@stored_elements
  end
  
  @@stored_specs = {}
  @@stored_routes = []
  @@stored_elements = {}

  def self.store_page_spec(pagename, parents)
    @@stored_specs[pagename] = PageSpec.new(pagename, parents)
  end

  def self.store_route(source_page, target_page, action, prerequisites)
    @@stored_routes.push({source_page: source_page,
                   target_page: target_page,
                   action: action,
                   prerequisites: prerequisites})
  end

  def self.store_element(page, options_hash, action, type)
    @@stored_elements[page] ||= []
    @@stored_elements[page].push({options_hash: options_hash, action: action, type: type})
  end

  def self.store_id_element(page, element_type, id_hash, action)
    options_hash = { element_type: element_type }.merge(id_hash)
    self.store_element(page, options_hash, action, :id)
  end

  def self.store_wait_element(page, element_type, id_hash, action)
    options_hash = { element_type: element_type }.merge(id_hash)
    self.store_element(page, options_hash, action, :wait)
  end

end

class Router

  def initialize(world)
    @world = world
    @page_specs = {}
    RouterStore.stored_specs.each_pair do |pagename, pagespec|
      @page_specs[pagename] = pagespec.empty_copy
    end

    RouterStore.stored_routes.each do |route|
      target_page = CoreUtils.find_class( route[:target_page] )
      @page_specs[ route[:source_page] ].add_route( target_page, route[:action], route[:prerequisites])
    end

    RouterStore.stored_elements.each_pair do |page, data|
      data.each do |item|
        element = CoreElement.new(:ident, @world, item[:options_hash])
        @page_specs[page].add_wait_element(element, item[:action]) if item[:type] == :wait
        @page_specs[page].add_id_element(element, item[:action])   if item[:type] == :id
      end
    end

    parents = []
    @page_specs.values.each do |spec|
      spec.parents.each do |parent|
        spec.inherit_details(@page_specs[parent])
        parents.push( parent )
      end
    end

    parents.uniq.each do |parent|
      @page_specs.delete(parent)
    end

    create_dot_file_from_graph if @world.configuration['CREATE_DOT_GRAPH'] == 'true'
  end

  def wait_for_page_to_load(target_page = @world.current_page.class)
    @world.logger.debug "Waiting on [#{target_page}] to load..."
    timeout = 20
    timeout = 60 if @world.configuration["BROWSER"] == "internet_explorer"

    start_time = Time.now()
    CoreUtils.wait_until(timeout) { @page_specs[target_page].done_waiting? }
    @world.logger.debug "Page loaded after [#{(Time.now - start_time).round(0)}] seconds"
  end

  def application_is_on_page?(page_class)
    @world.logger.debug "Attempting to ID page [#{page_class}]"
    @page_specs[page_class].id_page
  end

  def find_current_page
    @page_specs.keys.each do |page_class|
      return page_class if application_is_on_page?(page_class)
    end
    return "Could not find current page!"
  end

  def assert_application_is_on_page(page_class)
    @world.logger.validation "Ensuring that application is on page [#{page_class}]"

    unless CoreUtils.wait_until(3){application_is_on_page?(page_class)}
      @world.logger.debug "Application was not on the [#{page_class}], attempting to find current page"
      current_page = find_current_page
      raise "ERROR: The Application is on the wrong page!\n\tOZ expected that page to be [#{page_class}] but found [#{current_page}]!\n"
    end
  end

  def get_routes_between(start_page, destination_page, visited_page_paths = { start_page => [] }, open_pages = [])
    @world.logger.debug "Searching for path from [#{start_page}] to [#{destination_page}]..."
    current_path = visited_page_paths[start_page]
    start_spec = @page_specs[start_page]
    next_pages = start_spec.connected_pages - visited_page_paths.keys

    next_pages.each do |page|
      route = start_spec.get_route_to(page)
      combined_path = current_path + [ route ]

      return combined_path if destination_page == page

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
      @page_specs.each_pair do |start_page, spec|
          spec.routes.each_pair do |action, route|
              graph_file.write "#{start_page} -> #{route.target_page}[color=\"green\", label=\"#{route.action}\"];\n" unless route.target_page == start_page
          end
      end
      graph_file.write "}"
      graph_file.close

      @world.logger.debug "Done!"
  end

end