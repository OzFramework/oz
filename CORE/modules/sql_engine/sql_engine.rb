require_relative '../../../utils/oz_loader'
OzLoader.check_gems(%w[sequel], 'SQLEngine')
require 'sequel'

module OzFramework
  ##
  # SQL Engine is a wrapper for the connection of the Sequel Gem within Oz.
  # Configuration for connections sits within `tooling.yml` inside of the configuration folder.
  # An example on has been included in the sql_connector folder.

  class SQLEngine

    def self.world_name
      :sql_engine
    end

    attr_reader :db

    def initialize(world, db_name = nil)
      @world = world
      @connection_info = @world.configuration.tooling[:databases]
      @db_name = db_name
    end

    def connect(db_name = @db_name)
      raise "You never specified a Database to connect to!" if db_name.nil?

      @db = Sequel.connect(@connection_info[db_name])
    end

    def disconnect
      @db.disconnect
    end

  end
end