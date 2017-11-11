class ButtonElement < CoreElement
    def self.type
        :button
    end

    def assign_element_type
        @options[:element_type] = :button unless @options[:element_type]
        super
    end

end