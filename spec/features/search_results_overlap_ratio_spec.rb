# frozen_string_literal: true
require 'spec_helper'

feature 'spatial search results overlap ratio' do
  scenario 'result bboxes fully contained, overlap ratio applied to relevancy' do
    allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return 200

    # BBox param is the US upper midwest and Canada, roughly centered on the state of Minnesota
    visit search_catalog_path(
      bbox: '-103.196521 39.21962 -84.431873 53.63497',
      'f[dct_provenance_s][]': 'Minnesota'
    )

    # MN State result
    # Slightly bigger bbox / result bbox fits bbox param best
    expect(position_in_result_page(page, 'e9c71086-6b25-4950-8e1c-84c2794e3382')).to eq 1

    # MN State result
    # Slightly smaller bbox / result bbox fits bbox param second best
    expect(position_in_result_page(page, '2eddde2f-c222-41ca-bd07-2fd74a21f4de')).to eq 2

    # TC Metro result
    # Smaller bbox / result bbox fits bbox param third
    expect(position_in_result_page(page, '02236876-9c21-42f6-9870-d2562da8e44f')).to eq 3
  end

  scenario 'three bboxes overlap, but none are fully contained, overlap ratio should still impact relevancy' do
    allow(Settings).to receive(:OVERLAP_RATIO_BOOST).and_return 200

    # BBox param is the center to western edge of New York state and Canada, roughly centered on Lake Ontario
    visit search_catalog_path(
      bbox: '-83.750499 40.41709 -74.368175 47.963663',
      'f[dct_provenance_s][]': 'Cornell'
    )

    # NY State result
    # Bigger bbox / result bbox overlaps bbox param best
    expect(position_in_result_page(page, 'cugir-008186')).to be < 4

    # NY State result
    # Bigger bbox / result bbox overlaps bbox param best (score tie)
    expect(position_in_result_page(page, 'cugir-008186-no-downloadurl')).to be < 4

    # NY Adirondak Region result
    # Smaller bbox / result bbox overlaps bbox param the least
    expect(position_in_result_page(page, 'cugir-007741')).to eq 4
  end
end

def position_in_result_page(page, id)
  results = []
  page.all('div.documentHeader.row').each do |div|
    results << div['data-layer-id']
  end
  results.index(id) + 1
end
