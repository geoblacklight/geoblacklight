require 'spec_helper'

feature 'Search' do
  scenario 'Suppressed records are hidden' do
    visit '/?q=Sanborn+Map+Company'
    expect(page).to have_css '.document', count: 1
  end

  scenario 'When searching child records from a parent record, supressed records are not hidden' do
    visit '/?f[dc_source_sm][]=princeton-1r66j405w&q='
    expect(page).to have_css '.document', count: 2
  end
end
