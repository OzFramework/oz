require 'rspec'
require 'rspec/mocks'
require 'world_extensions/core_world'
require_relative 'fixtures/classes/shinies'

describe CoreWorld do
  before { ENV['OZ_CONFIG_DIR'] = './spec/fixtures' }

  context CoreWorld::PaveStones do
    let(:world){ Object.new }
    after { CoreWorld::PaveStones[:logger] = OzLogger } # This persists across rspec steps because lolsingletons...

    it 'allows overriding of the classes that will be used when creating the world' do
      CoreWorld::PaveStones[:logger] = ShinyNewBrick
      world.extend CoreWorld
      world.create_world
      expect(world.logger).to be_a ShinyNewBrick
    end
  end
  # Adding these tests because I don't want people hard overriding the Oz Core Modules since it causes
  # unpredictable results, they may seem like beating a dead horse, but bear with me.
  context 'Adding Oz Modules to the test world' do
    let(:world) { Object.new.yield_self { |it| it.extend CoreWorld; it.create_world; it }}

    it('should have the OzLogger') do
      expect(world.logger).to be_a OzLogger
    end

    it('should have the Configuration Engine') do
      expect(world.configuration).to be_a ConfigurationEngine
    end

    it('should have the Validation Engine') do
      expect(world.validation_engine).to be_a ValidationEngine
    end

    it('should have the Ledger') do
      expect(world.ledger).to be_a Ledger
    end

    it('should have the Router') do
      expect(world.router).to be_a Router
    end

    it('should have the Browser Engine') do
      expect(world.browser_engine).to be_a BrowserEngine
    end

    it('should have the Data Engine') do
      expect(world.data_engine).to be_a DataEngine
    end

  end

  context 'adding an oz module at runtime' do
    let(:world) { Object.new.yield_self { |it| it.extend CoreWorld; it.create_world; it }}
    before { world.register_world_module ShinyWorldModule }
    it('should now allow me to interact with the world module i added') do
      expect(world.shiny_thing).to be_a ShinyWorldModule
    end
  end
end