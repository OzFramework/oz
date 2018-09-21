
class PageBlueprint

  attr_accessor :source_page, :parents, :routes, :id_elements, :wait_elements

  Route = Struct.new(:target_page, :action, :prerequisites)

  def initialize(source_page, parents)
    @source_page = source_page
    @parents = parents
    @routes = {}
    @id_elements = []
    @wait_elements = []
  end

  def empty_copy
    PageBlueprint.new(@source_page, @parents)
  end

  def inherit_details(parent_page)
    @routes = parent_page.routes.merge(@routes)
    @id_elements += parent_page.id_elements
    @wait_elements += parent_page.wait_elements
  end

  def add_route(target_page, action, prerequisites)
    @routes[target_page] ||= Route.new( target_page, action, [ prerequisites ].flatten )
  end

  def add_id_element(element, action)
    @id_elements.push({element: element, action: action})
  end

  def add_wait_element(element, action)
    @wait_elements.push({element: element, action: action})
  end

  def get_route_to(page)
    @routes[page]
  end

  def connected_pages
    @routes.keys
  end

  def id_page
    raise "ERROR: Page [#{@source_page}] does not define any identifying elements!" if @id_elements == []

    @id_elements.each do |item|
      if item[:action] == :not_visible
        return false if item[:element].present?
      else
        return false unless (item[:element].value =~ item[:action])
      end
    end

    return true
  end

  def done_waiting?
    done_waiting = true
    @wait_elements.each do |item|
      element_present = item[:element].present?

      if item[:action] == :wait_until_present
        done_waiting = false unless element_present
      else
        done_waiting = false if element_present
      end
    end
    return done_waiting
  end

end
