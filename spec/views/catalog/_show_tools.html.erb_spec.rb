# frozen_string_literal: true
require 'spec_helper'

describe 'catalog/_show_tools.html.erb', type: :view do
  let(:document) { SolrDocument.new id: 'xyz', format: 'a' }
  let(:blacklight_config) { Blacklight::Configuration.new }
  let(:context) { Blacklight::Configuration::Context.new(controller) }

  before do
    assign :document, document
    allow(view).to receive(:blacklight_config).and_return blacklight_config
    allow(view).to receive(:blacklight_configuration_context).and_return context
  end

  describe 'document actions' do
    let(:document_actions) { blacklight_config.show.document_actions }

    it 'renders a document action' do
      allow(view).to receive(:some_action_solr_document_path).with(document, any_args).and_return 'x'
      document_actions[:some_action] = Blacklight::Configuration::ToolConfig.new partial: 'document_action'
      render partial: 'catalog/show_tools'
      expect(rendered).to have_link 'Some action', href: 'x'
    end

    context 'without any document actions defined' do
      before do
        document_actions.clear
      end

      it 'does not display the tools' do
        render partial: 'catalog/show_tools'

        expect(rendered).to be_blank
      end
    end
  end
end
