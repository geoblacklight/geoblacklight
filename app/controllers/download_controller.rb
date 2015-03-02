class DownloadController < ApplicationController
  include Blacklight::SolrHelper

  def show
    @response, @document = get_solr_response_for_doc_id params[:id]
    restricted_should_authenticate
    response = check_type
    validate response
    respond_to do |format|
      format.json { render json: flash, response: response }
      format.html { render json: flash, response: response }
    end
  end

  def file
    # Grab the solr document to check if it should be public or not
    @response, @document = get_solr_response_for_doc_id(file_name_to_id(params[:id]))
    restricted_should_authenticate
    send_file "tmp/cache/downloads/#{params[:id]}.#{params[:format]}", type: 'application/zip', x_sendfile: true
  end

  def hgl
    @response, @document = get_solr_response_for_doc_id params[:id]
    if params[:email]
      response = Geoblacklight::HglDownload.new(@document, params[:email]).get
      if response.nil?
        flash[:danger] = t 'geoblacklight.download.error'
      else
        flash[:success] = t 'geoblacklight.download.hgl_success'
      end
      respond_to do |format|
        format.json { render json: flash, response: response }
        format.html { render json: flash, response: response }
      end
    else
      render layout: false
    end
  end

  private

  def check_type
    case params[:type]
    when 'shapefile'
      response = ShapefileDownload.new(@document).get
    when 'kmz'
      response = KmzDownload.new(@document).get
    when 'geojson'
      response = GeojsonDownload.new(@document).get
    when 'geotiff'
      response = GeotiffDownload.new(@document).get
    end
    response
  end

  def validate(response)
    if response.nil?
      flash[:danger] = view_context.content_tag(:span, t('geoblacklight.download.error'), data: { download: 'error', download_id: params[:id], download_type: "generated-#{params[:type]}"})
    else
      flash[:success] = view_context.link_to(t('geoblacklight.download.success', title: response), download_file_path(response), data: { download: 'trigger', download_id: params[:id], download_type: "generated-#{params[:type]}"})
    end
  end

  # Checks whether a document is public, if not require user to authenticate
  def restricted_should_authenticate
    unless @document.public?
      authenticate_user!
    end
  end

  def file_name_to_id(file_name)
    file_name.split('-')[0..-2].join('-')
  end
end
