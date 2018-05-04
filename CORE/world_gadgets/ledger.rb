

class Ledger

    class << self
        def define_object(name)
            define_method(name) { @objects[name] }
        end
    end

    def initialize(world)
        @world = world
        @pages_visited = []
        @filled_data = {}
        @objects = {}
    end

    def save_page_visit(page_name)
        @pages_visited << [page_name, Time.now()]
    end

    def last_page
        @pages_visited[-1].first
    end

    def pages_visited
        @pages_visited.map {|entry| entry.first}
    end

    def record_fill(element_name, value)
        @world.logger.warn "[ERROR RECORDING FILL] element_name expected to be a Symbol! Instead was given a [#{element_name.class}]!" unless element_name.is_a? Symbol
        page_name = @world.current_page.class
        @filled_data[page_name] = {} unless @filled_data[page_name]
        @filled_data[page_name][element_name] = value
    end

    def get_value(page_class, element_name)
        @world.logger.warn "[ERROR GETTING VALUE] page_class expected to be a Class! Instead was given a [#{page_class.class}]!" unless page_class.is_a? Class
        @world.logger.warn "[ERROR GETTING VALUE] element_name expected to be a Symbol! Instead was given a [#{element_name.class}]!" unless element_name.is_a? Symbol
        return nil unless @filled_data[page_class]
        @filled_data[page_class][element_name]
    end

    def get_page_values(page_class)
      @world.logger.warn "[ERROR GETTING VALUE] page_class expected to be a Class! Instead was given a [#{page_class.class}]!" unless page_class.is_a? Class
      return {} unless @filled_data[page_class]
      @filled_data[page_class]
    end

    def save_object(object_name, object)
        @objects[object_name] = object
        self.class.define_object object_name
    end

    def delete_object(object_name)
        @objects[object_name] = nil
    end

    def has_object?(object_name)
        @objects[object_name] != nil
    end

    def print_all
        print "==========================\n"
        print "===   LEDGER VALUES   ===\n"
        print "==========================\n"

        print "\n  === VISITED_PAGES ===\n"
        @pages_visited.each do |item|
            print "    #{item[0]} @ #{item[1].asctime}\n"
        end

        print "\n  === FILLED_DATA ===\n"
        @filled_data.each_pair do |page_name, elements|
            print "    #{page_name}\n"
            elements.each_pair do |element, value|
                print "      #{element}: #{value}\n"
            end
        end

        @objects.each_pair do |key, value|
            print "\n  === #{key.to_s.upcase} ===\n"
            truncate = @world.configuration['LEDGER_TRUNCATION']
            if value.class == Hash
                CoreUtils.recursively_print_hash(value, truncate, indent='    ')
            elsif value.class < Struct
              CoreUtils.recursively_print_hash(value.to_h, truncate, indent='    ')
            elsif value.class == Array
                CoreUtils.recursively_print_array(value, truncate, indent='    ')
            else
                print "    #{value}\n"
            end
        end
        print "\n==========================\n"
    end

  def cleanup
      print_all if @world.configuration['PRINT_LEDGER']
  end

end
