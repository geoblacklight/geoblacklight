require 'nokogiri'
require 'httparty'
require 'net/http'

class Layer
  include HTTParty
  format :json

  def self.getInfo(params)
    url = params['URL']
    params['BBOX'] = formatLatLng(params['BBOX'])
    puts params
    get(url, :query => params.except('URL'))
  end
end

class DownloadController < ApplicationController
  def file
    
    send_file "tmp/data/#{params['q']}", :type=>"application/zip", :x_sendfile=>true 

  end

  def shapefile
 
    puts session['session_id']
    uuid = params['layer_slug_s']
    layername = params['layer_id_s']
    wfsurl = params['solr_wfs_url']
    
    params = {:service => 'wfs', :version => '2.0.0', :request => 'GetFeature', :srsName => 'EPSG:4326', :outputformat => 'SHAPE-ZIP', :typeName => layername}
    
    # token = SecureRandom.base64(8).tr('+/=lIO0', 'abc123')
    error = ''

    if !Dir.exists?('tmp/data')
      Dir.mkdir('tmp/data')
    end
    if (!File.file?("tmp/data/#{uuid}-shapefile.zip"))
      File.open("tmp/data/#{uuid}-shapefile.zip", 'wb')  do |f|
          puts "#{uuid}-shapefile.zip created"
          dl = HTTParty.get(wfsurl, :query => params)
          if dl.headers['content-type'] == 'application/zip'
            f.write dl.parsed_response
          else
            error = dl.parsed_response
          end
      end
    else
      puts "#{uuid}-shapefile.zip already exists"
    end
    respond_to do |format|
      if error.length > 0
         puts 'error!'
        format.json { render :json => {:error => error}}
        File.delete("tmp/data/#{uuid}-shapefile.zip")
        puts "#{uuid}-shapefile.zip deleted"
      else
        format.json { render :json => {:data => "#{uuid}-shapefile.zip"}}
      end
    end

  end

  def kml
    layername = params['layer_id_s']
    puts layername
    bbox = [params['solr_sw_pt_1_d'], params['solr_sw_pt_0_d'], params['solr_ne_pt_1_d'], params['solr_ne_pt_0_d']]
    bbox = bbox.join(',')
    wmsurl = params['solr_wms_url']
    uuid = params['layer_slug_s']
    puts bbox

    params = {:service => 'wms', :version => '1.1.0', :request => 'GetMap', :srsName => 'EPSG:900913', :format => 'application/vnd.google-earth.kmz', :layers => layername, :bbox => bbox, :width => 2000, :height => 2000}
    
    error = ''

    if !Dir.exists?('tmp/data')
      Dir.mkdir('tmp/data')
    end
    if (!File.file?("tmp/data/#{uuid}.kmz"))
      File.open("tmp/data/#{uuid}.kmz", 'wb')  do |f|
          puts "#{uuid}.kmz created"
          dl = HTTParty.get(wmsurl, :query => params)
          puts dl.headers.inspect
          puts dl.request.inspect
          if dl.headers['content-type'] == 'application/vnd.google-earth.kmz'
            f.write dl.parsed_response
          else
            error = dl.parsed_response
          end
      end
    else
      puts "#{uuid}.kmz already exists"
    end
    respond_to do |format|
      if error.length > 0
         puts 'error!'
        format.json { render :json => {:error => error}}
        File.delete("tmp/data/#{uuid}.kmz")
        puts "#{uuid}.kmz deleted"
      else
        format.json { render :json => {:data => "#{uuid}.kmz"}}
      end
    end
  end
end
