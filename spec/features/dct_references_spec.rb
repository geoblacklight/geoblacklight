require 'json'
require 'spec_helper'

URIs = Geoblacklight::Constants::URI

def parse_dct n
  doc = JSON.parse(File.open("spec/fixtures/test-dct-references#{n}.json").read)
  refs = JSON.parse(doc['dct_references_s'])
  [doc, refs]
end

feature 'DCT:References Parsing' do
  scenario 'Case 1: Minimal case of HTML metadata only' do
    doc, refs = parse_dct 1
    expect(refs[URIs[:html]]).to match %r'.*/.*html'
  end
  
  scenario 'Case 2: Minimal case of FGDC metadata, a URL (homepage), and WMS tile server' do
    doc, refs = parse_dct 2
    expect(refs[URIs[:fgdc]]).to match %r'.*/fgdc.xml'
    expect(refs[URIs[:wms]]).to match  %r'.*/wms'
    expect(refs[URIs[:url]]).to match  %r'.*/homepage'
  end
  
  scenario 'Case 3: ISO & MODS metadata, a URL, and WMS tile server' do
    doc, refs = parse_dct 3
    expect(refs[URIs[:iso19139]]).to match %r'.*/iso19139.xml'
    expect(refs[URIs[:mods]]).to match %r'.*/mods.xml'
    expect(refs[URIs[:url]]).to match  %r'.*/homepage'
    expect(refs[URIs[:wms]]).to match %r'.*/wms'
  end

  scenario 'Case 4: FGDC metadata and IIIF tile server' do
    doc, refs = parse_dct 4
    expect(refs[URIs[:fgdc]]).to match %r'.*/fgdc.xml'
    expect(refs[URIs[:iiif]]).to match %r'.*/iiif'
  end

  scenario 'Case 5: ISO & MODS metadata, a URL, Shapefile ZIP and WFS, and WMS tile server' do
    doc, refs = parse_dct 5
    expect(doc['dc_format_s']).to eq 'Shapefile'
    expect(doc['layer_geom_type_s']).to match %r'Point|Line|Polygon'
    expect(refs[URIs[:download]]).to match %r'.*/data.zip'
    expect(refs[URIs[:iso19139]]).to match %r'.*/iso19139.xml'
    expect(refs[URIs[:mods]]).to match %r'.*/mods.xml'
    expect(refs[URIs[:wms]]).to match %r'.*/wms'
    expect(refs[URIs[:wfs]]).to match %r'.*/wfs'
    expect(refs[URIs[:url]]).to match  %r'.*/homepage'
  end
  
  scenario 'Case 6: ISO & MODS metadata, GeoTIFF ZIP and WCS, and WMS tile server' do
    doc, refs = parse_dct 6
    expect(doc['dc_format_s']).to eq 'GeoTIFF'
    expect(doc['layer_geom_type_s']).to eq 'Raster'
    expect(refs[URIs[:download]]).to match %r'.*/data.zip'
    expect(refs[URIs[:iso19139]]).to match %r'.*/iso19139.xml'
    expect(refs[URIs[:mods]]).to match %r'.*/mods.xml'
    expect(refs[URIs[:wms]]).to match %r'.*/wms'
    expect(refs[URIs[:wcs]]).to match %r'.*/wcs'
  end
  
  scenario 'Case 7: No metadata, GeoJSON' do
    doc, refs = parse_dct 7
    expect(doc['dc_format_s']).to eq 'Shapefile'
    expect(doc['layer_geom_type_s']).to match %r'Point|Line|Polygon'
    expect(refs[URIs[:download]]).to match %r'.*/data.json'
  end
  
  scenario 'Case 8: HTML metadata and WMS tile server' do
    doc, refs = parse_dct 8
    expect(doc['dc_format_s']).to eq 'Shapefile'
    expect(refs[URIs[:download]]).to eq nil
    expect(refs[URIs[:html]]).to match %r'.*/.*.html'
    expect(refs[URIs[:wms]]).to match %r'.*/wms'
  end

end