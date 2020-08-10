# frozen_string_literal: true
require 'spec_helper'

describe 'catalog/_results_pagination.html.erb', type: :view do
  it 'will have a #pagination wrapping div' do
    allow(view).to receive_messages(show_pagination?: false)
    render
    expect(rendered).to have_css '#pagination'
  end
end
