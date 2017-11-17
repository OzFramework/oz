

class CorePage

    def create_elements
        raise "ERROR: The [#{self.class}] page does not define a create_elements method!!!"
    end

    def create_common_elements; end

    def group(*args)
        ElementGroup.new(args)
    end
    
    def add_element(name, options, element_class)
        new_element = element_class.new(name, @world, options)
        @elements[new_element.name] = new_element
        return new_element
    end

    def add_text_field(name, options)
        return add_element(name, options, TextFieldElement)
    end

    def add_static_text(name, options)
        return add_element(name, options, StaticTextElement)
    end

    def add_button(name, options)
        return add_element(name, options, ButtonElement)
    end

    def add_select_list(name, options)
        add_element(name, options, SelectListElement)
    end

    def add_checkbox(name, options)
        add_element(name, options, CheckboxElement)
    end
end