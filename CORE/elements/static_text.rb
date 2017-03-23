
class StaticTextElement < CoreElement
    def self.type
        :static_text
    end

    def validate(data)
        super(data)
        if active
            @world.logger.validation "Checking that [#{@name}] contains [#{data}]"
            raise "ERROR! [#{@name}] has incorrect value!\n\tFOUND   : #{value.inspect}\n\tEXPECTED: #{data.inspect}\n\n" unless value == data
        end
    end
end