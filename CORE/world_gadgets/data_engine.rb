

class DataEngine

  def initialize(logger=nil)
    @logger = logger
  end

  def load_data_from_yml(filename)
    @logger.debug "Loading data from file #{filename}" if @logger
    begin
      data = YAML.load_file(filename)
      return data
    rescue Psych::SyntaxError => e
      raise "ERROR: OZ could not parse this YML file!\n"\
		        "\tMY GUESS: You have a syntax error in your .yml file\n"\
		        "\tYML_FILE: #{filename}\n"\
		        "\tNOTE: Could be from inherited page YML file\n"
      "\tORIGINAL MESSAGE: #{e.message}\n\n"
    rescue Errno::ENOENT => e
      raise "ERROR: OZ could not parse this YML file!\n"\
                "\tMY FIRST GUESS: The path to this YML file is incorrect.\n"\
                "\tMY SECOND GUESS: The yml file is missing.\n"\
                "\tYML_FILE: #{filename}\n"\
                "\tORIGINAL MESSAGE: #{e.message}\n\n"
    end
  end

  def get_yml_data(data_type, filename, data_name)
    raw_data = load_data_from_yml(filename)[data_type]
    default_data = raw_data['DEFAULT']
    raise "DEFAULT key is empty for #{filename}!" if default_data == nil
    data = raw_data[data_name.upcase.gsub(' ','_')]
    return data ? default_data.merge!(data) : default_data
  end

  def get_input_data(filename, data_name)
    get_yml_data("INPUT_DATA", filename, data_name)
  end

  def get_expected_data(filename, data_name)
    get_yml_data("EXPECTED_DATA", filename, data_name)
  end

end