require 'rspec'
require 'oz/world_gadgets/router/router'

class TestPage
end

describe Oz::Router do
  before do
    stub_const('Oz::RouterStore',
               class_double('Oz::RouterStore', registry: [TestPage], generate_graph: [])
    )
  end
  let!(:configuration) { double('configuration', '[]': nil) }
  let!(:router) { Oz::Router.new(self) }

  context :page_class_for do
    it 'allows me to find pages that were registered during framework initialization' do
      expect(router.page_class_for('TestPage')).to eql TestPage
    end
  end
end