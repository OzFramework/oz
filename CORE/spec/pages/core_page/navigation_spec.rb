require 'rspec'
require 'pages/core_page'
require 'world_gadgets/router/router_store'
require 'world_gadgets/router/core_page_navigation'



describe CorePage do
  context :navigation do
    context 'When core page is inherited' do
      class ATestPage < CorePage
        add_id_element(:div, //, xpath: '//div')
      end
      it 'should add a blueprint for ATestPage to the RouterStore' do
        expect(RouterStore.instance_variable_get(:@stored_blueprints).keys).to include(ATestPage)
      end

      it 'should add an entry to the registry for ATestPage' do
        expect(RouterStore.registry).to include(ATestPage)
      end

    end

  end
end