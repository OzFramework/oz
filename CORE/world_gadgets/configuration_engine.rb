require 'json'

class ConfigurationEngine

  def initialize
    @config_data = JSON.parse(File.read("#{ENV['OZ_CONFIG_DIR']}/user_config.json"))
    merge_system_config
    load_environment
  end

  def load_environment
    environments = JSON.parse(File.read("#{ENV['OZ_CONFIG_DIR']}/environment_config.json"))
    environment_name = @config_data['TEST_ENVIRONMENT']
    @config_data['ENVIRONMENT'] = environments[environment_name]
    raise "ERROR: Environment [#{environment_name}] is not defined in the environment_config.json file!
        Available options are: #{environments.keys}\n\n" unless environments.keys.include? environment_name
  end

  def merge_system_config
    @config_data.keys.each do |option_name|
      if ENV[option_name]
        puts "Loading value [#{ENV[option_name]}] for ENV variable [#{option_name}] from system environment."
        @config_data[option_name] = ENV[option_name]=='true' ? true : ENV[option_name]
        @config_data[option_name] = ENV[option_name]=='false' ? false : ENV[option_name]
      end
    end
    @config_data['CLOSE_BROWSER'] = true if @config_data['USE_GRID']
    @config_data['APP_NAME'] = ENV['OZ_APP_NAME']
    @config_data['CORE_DIR'] = ENV['OZ_CORE_DIR']
  end

  def [](key)
    @config_data[key]
  end

  def to_s
    result = "\n====== Configuration ======\n"
    @config_data.each_pair { |key, value|
      result += "#{key}: #{value.to_s}\n"
    }
    return result + '===========================\n'
  end

end