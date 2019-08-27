require 'rspec'
require 'rspec/mocks'
require 'oz/world_extensions/core_world'

class ShinyNewBrick
  def initialize(*args); end
  def method_missing(*args); end
end

class ShinyWorldModule
  def self.world_name
    :shiny_thing
  end
  def initialize(*args); end
  # for intellisense
  def shiny_thing; end
end

describe Oz::CoreWorld do
  before { ENV['OZ_CONFIG_DIR'] = './spec/fixtures' }

  context Oz::CoreWorld::PaveStones do
    let(:world){ Object.new }
    after { Oz::CoreWorld::PaveStones[:logger] = Oz::OzLogger } # This persists across rspec steps because lolsingletons...

    it 'allows overriding of the classes that will be used when creating the world' do
      Oz::CoreWorld::PaveStones[:logger] = ShinyNewBrick
      world.extend Oz::CoreWorld
      world.create_world
      expect(world.logger).to be_a ShinyNewBrick
    end
  end
  # Adding these tests because I don't want people hard overriding the Oz Core Modules since it causes
  # unpredictable results, they may seem like beating a dead horse, but bear with me.
  context 'Adding Oz Modules to the test world' do
    let(:world) { Object.new.yield_self { |it| it.extend Oz::CoreWorld; it.create_world; it }}

    it('should have the OzLogger') do
      expect(world.logger).to be_a Oz::OzLogger
    end

    it('should have the Configuration Engine') do
      expect(world.configuration).to be_a Oz::ConfigurationEngine
    end

    it('should have the Validation Engine') do
      expect(world.validation_engine).to be_a Oz::ValidationEngine
    end

    it('should have the Ledger') do
      expect(world.ledger).to be_a Oz::Ledger
    end

    it('should have the Router') do
      expect(world.router).to be_a Oz::Router
    end

    it('should have the Browser Engine') do
      expect(world.browser_engine).to be_a Oz::BrowserEngine
    end

    it('should have the Data Engine') do
      expect(world.data_engine).to be_a Oz::DataEngine
    end

  end

  context 'adding an oz module at runtime' do
    let(:world) { Object.new.yield_self { |it| it.extend Oz::CoreWorld; it.create_world; it }}
    before { world.register_world_module ShinyWorldModule }
    it('should now allow me to interact with the world module i added') do
      expect(world.shiny_thing).to be_a ShinyWorldModule
    end
  end
end