#!/usr/bin/env ruby
require 'json'
require 'geoblacklight'

def do_write n, doc
  unless File.size?("spec/fixtures/test-dct-references#{n}.json")
    puts "Writing spec/fixtures/test-dct-references#{n}.json"
    File.open("spec/fixtures/test-dct-references#{n}.json", 'wb') {|f| f << JSON.pretty_generate(doc) }
  end
end

URIs = Geoblacklight::Constants::URI
selected = JSON.parse(File.open('schema/examples/selected.json').read)

# scenario 'Case 1: Minimal case of HTML metadata only' do
doc = selected.sample
doc['dct_references_s'] = {
  URIs[:html] => "http://example.com/#{doc['uuid']}/metadata.html"
}.to_json
do_write 1, doc

# scenario 'Case 2: Minimal case of FGDC metadata, a URL (homepage), and WMS tile server' do
doc = selected.sample
doc['dct_references_s'] = {
  URIs[:fgdc] => "http://example.com/#{doc['uuid']}/fgdc.xml",
  URIs[:url] => "http://example.com/#{doc['uuid']}/homepage",
  URIs[:wms] => doc['solr_wms_url']
}.to_json
do_write 2, doc

# scenario 'Case 3: ISO & MODS metadata, a URL, and WMS tile server' do
doc = selected.sample
doc['dct_references_s'] = {
  URIs[:iso19139] => "http://example.com/#{doc['uuid']}/iso19139.xml",
  URIs[:mods] => "http://example.com/#{doc['uuid']}/mods.xml",
  URIs[:url] => "http://example.com/#{doc['uuid']}/homepage",
  URIs[:wms] => doc['solr_wms_url']
}.to_json
do_write 3, doc

# scenario 'Case 4: FGDC metadata and IIIF tile server' do
doc = selected.sample
doc['dct_references_s'] = {
  URIs[:fgdc] => "http://example.com/#{doc['uuid']}/fgdc.xml",
  URIs[:iiif] => "http://example.com/iiif"
}.to_json
do_write 4, doc

# scenario 'Case 5: ISO & MODS metadata, a URL, Shapefile ZIP and WFS, and WMS tile server' do
doc = selected.sample
while doc['dc_format_s'] != 'Shapefile'
  doc = selected.sample  
end
raise ArgumentError, doc['dc_format_s'] unless doc['dc_format_s'] == 'Shapefile'
doc['dct_references_s'] = {
  URIs[:download] => "http://example.com/#{doc['uuid']}/data.zip",
  URIs[:iso19139] => "http://example.com/#{doc['uuid']}/iso19139.xml",
  URIs[:mods] => "http://example.com/#{doc['uuid']}/mods.xml",
  URIs[:url] => "http://example.com/#{doc['uuid']}/homepage",
  URIs[:wms] => doc['solr_wms_url'],
  URIs[:wfs] => doc['solr_wfs_url']
}.to_json
do_write 5, doc

# scenario 'Case 6: ISO & MODS metadata, GeoTIFF ZIP and WCS, and WMS tile server' do
doc = selected.sample
while doc['dc_format_s'] != 'GeoTIFF'
  doc = selected.sample  
end
doc['dct_references_s'] = {
  URIs[:download] => "http://example.com/#{doc['uuid']}/data.zip",
  URIs[:iso19139] => "http://example.com/#{doc['uuid']}/iso19139.xml",
  URIs[:mods] => "http://example.com/#{doc['uuid']}/mods.xml",
  URIs[:wms] => doc['solr_wms_url'],
  URIs[:wcs] => doc['solr_wcs_url']
}.to_json
do_write 6, doc

# scenario 'Case 7: No metadata, GeoJSON'
doc = selected.sample
while doc['dc_format_s'] != 'Shapefile'
  doc = selected.sample  
end
doc['dct_references_s'] = {
  URIs[:download] => "http://example.com/#{doc['uuid']}/data.json"
}.to_json
do_write 7, doc

# scenario 'Case 8: HTML metadata and WMS tile server'
doc = selected.sample
doc['dct_references_s'] = {
  URIs[:html] => "http://example.com/#doc['uuid']/metadata.html",
  URIs[:wms] => doc['solr_wms_url']
}.to_json
do_write 8, doc





