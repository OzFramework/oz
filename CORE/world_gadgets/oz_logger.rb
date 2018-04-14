class OzLogger
  # We can't just name this class 'Logger' because Cucumber has a class named that already :(

  def self.DEBUG  ; 1 end
  def self.INFO   ; 2 end
  def self.ACTION ; 4 end
  def self.WARN   ; 8 end

  def initialize(world)
    @world = world
    @debug_level = OzLogger.send(@world.configuration['LOG_LEVEL'].to_sym)
    @colorless = @world.configuration['COLORLESS_OUTPUT'] == true
  end

  def debug(message)
    prefix = '[ DEBUG    ]-> '
    prefix = prefix.gray unless @colorless
    puts prefix + "#{_color_escape(message, :gray, :default)}" if @debug_level <= self.class.DEBUG
  end

  def header(message)
    puts "#{_color_escape(message, :blue, :cyan)}" if @debug_level <= self.class.INFO and not @colorless
  end

  def action(message)
    prefix = '[ ACTION   ]-> '
    prefix = prefix.cyan unless @colorless
    puts prefix + "#{_color_escape(message, :default, :cyan)}" if @debug_level <= self.class.ACTION
  end

  def validation(message)
    prefix = '[ VALIDATE ]-> '
    prefix = prefix.green unless @colorless
    puts prefix + "#{_color_escape(message, :default, :green)}" if @debug_level <= self.class.ACTION
  end

  def validation_fail(message)
    prefix = '[ VALIDATE ]-> '
    prefix = prefix.red unless @colorless
    puts prefix + "#{_color_escape(message, :red, :black)}" if @debug_level <= self.class.ACTION
  end

  def warn(message)
    prefix = '[ WARNING  ]-> '
    prefix = prefix.orange unless @colorless
    puts prefix + "#{_color_escape(message, :orange, :red)}" if @debug_level <= self.class.WARN
  end

  def _color_escape(message, base_color, highlight_color)
    return message if @colorless
    captures = message.scan(/\[.*?\]/)
    message_segments = [message]

    captures.uniq.each do |capture|
      message_segments.each_with_index do |segment, index|
        message_segments[index] = segment.split(capture).insert(1, capture.gsub(/\[|\]/, '')) if segment[capture]
      end
      message_segments.flatten!
    end

    message = ''
    message_segments.each_with_index do |segment, index|
      message += index.even? ? segment.send(base_color) : segment.send(highlight_color)
    end
    return message
  end
end
