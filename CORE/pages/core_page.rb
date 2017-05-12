
# CorePage will be the basis for all other pages we create,
# there should be an instance of this page saved in the @world object upon each scenario's creation.
# Eventually this page will become the recorder/basis for how we will record interactions with the DB and others.

class CorePage

    ### Setup ###
    #############

    def initialize(world, root_page=false)
        @world = world
        @ledger = @world.ledger
        unless root_page
            @elements = {}
            create_common_elements
            create_elements
        end
    end

    ### Step Definition Methods ###
    ###############################

    def fill(data_name=nil)
        data_name ||= @world.data_target
        data = input_data(data_name)
        raise ArgumentError, "ERROR: Method: [input_data] of class [#{self.class}] should return a Hash\n" unless data.class == Hash

        data.each_key do |element_name|
            raise 'Element in data set does not exist on the page!' unless @elements.keys.include?(element_name)
            @elements[element_name].fill(data[element_name])
        end
    end

    def click_on(element_name)
        @elements[element_name].click
    end

    def validate_content
        data = expected_data()
        raise ArgumentError, "ERROR: Method: [expected_data] of class [#{self.class}] should return a Hash\n" unless data.class == Hash

        @elements.values.each do |element|
            element.validate(data[element.name])
        end
    end


    ### Data ###
    ############

    def input_data(data_name)
        @world.get_input_data(yml_file, data_name)
    end

    def expected_data(data_name = "DEFAULT")
        @world.get_expected_data(yml_file, data_name)
    end

    def yml_file
        #The extra long gunk here basically just looks for the file that has the 'create_elements' method defined inside it and replaces the .rb extension with .yml
        self.class.instance_method(:create_elements).source_location.first.gsub(/\.rb$/,".yml")
    end

    def browser
        @world.browser
    end

end