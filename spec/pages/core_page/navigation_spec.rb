require 'rspec'
require 'oz/pages/core_page'
require 'oz/world_gadgets/router/router_store'
require 'oz/world_gadgets/router/core_page_navigation'



describe Oz::CorePage do
  context :navigation do
    context 'When core page is inherited' do
      class ATestPage < Oz::CorePage
        add_id_element(:div, //, xpath: '//div')
      end
      it 'should add a blueprint for ATestPage to the RouterStore' do
        expect(Oz::RouterStore.instance_variable_get(:@stored_blueprints).keys).to include(ATestPage)
      end

      it 'should add an entry to the registry for ATestPage' do
        expect(Oz::RouterStore.registry).to include(ATestPage)
      end

    end

  end
end