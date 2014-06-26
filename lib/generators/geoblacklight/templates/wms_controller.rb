require 'nokogiri'

class Layer
  include HTTParty
  format :json

  def self.getInfo(params)
    url = params['URL']
    params['BBOX'] = formatLatLng(params['BBOX'])
    # puts 'hallo'
    # params.delete "URL"
    params.delete "action"
    params.delete "controller"
    puts params
    get(url, :query => params.except('URL'))
  end
end

# Refactor to a helper later on
def formatLatLng(val)
  formated_val = []
  val.split(',').each do |v|
    vFloat = v.to_f
    if vFloat > 180 || vFloat < -180
      while vFloat > 180
        vFloat -= 360
      end
      while vFloat < -180
        vFloat += 360
      end
      formated_val.push(vFloat)
    else
      formated_val.push(v)
    end
  end
  return formated_val.join(',')
end

class WmsController < ApplicationController
  def handle
    params["info_format"] = "text/html"
    response = Layer.getInfo(params)
    # puts response.inspect
    puts response.body
    puts response.request.inspect
    

    page = Nokogiri::HTML(response.body)
    table = {:values => []}
    page.css('th').each_with_index do |th|
      table[:values].push([th.text])
    end
    page.css('td').each_with_index do |td, i|
      table[:values][i].push(td.text)
    end

    errorresponse = {}

    if response.headers["content-type"].slice(0,8) == "text/xml"
      puts response.body.to_s
      errorresponse = Hash.from_xml(response.body).to_json
    end

    respond_to do |format|
      if response.headers["content-type"].slice(0,9) == "text/html"
        format.json { render :json => table}
      else
        format.json { render :json => errorresponse}
      end
      # if response.headers["content-type"] == "application/json"
    #     format.json { render :json => response }
    #   else
    #       if response.headers["content-type"] == "text/html"
    #         puts 'should be called'
    #         format.json { render :json => table}
    #       end
      #     # format.json { render :json => {"code" => "fail"}}
    #   end
    end
  end
end
