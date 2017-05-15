
class RouterStore

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

  def self.generate_graph(world)

    #Create copy of stored specs
    page_specs = {}
    @@stored_specs.each_pair do |pagename, pagespec|
      page_specs[pagename] = pagespec.empty_copy
    end

    #Copy Routes into specs
    @@stored_routes.each do |route|
      target_page = CoreUtils.find_class( route[:target_page] )
      page_specs[ route[:source_page] ].add_route( target_page, route[:action], route[:prerequisites])
    end

    #Copy Elements into specs
    @@stored_elements.each_pair do |page, data|
      data.each do |item|
        element = CoreElement.new(:ident, world, item[:options_hash])
        page_specs[page].add_wait_element(element, item[:action]) if item[:type] == :wait
        page_specs[page].add_id_element(element, item[:action])   if item[:type] == :id
      end
    end

    #Inherit all details from parents
    parents = []
    page_specs.values.each do |spec|
      spec.parents.each do |parent|
        spec.inherit_details(page_specs[parent])
        parents.push( parent )
      end
    end

    #Remove all parents from graph
    parents.uniq.each do |parent|
      page_specs.delete(parent)
    end

    return page_specs
  end

end