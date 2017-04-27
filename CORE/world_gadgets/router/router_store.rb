
class RouterStore

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