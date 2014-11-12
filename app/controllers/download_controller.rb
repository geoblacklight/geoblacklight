class DownloadController < ApplicationController
  include Blacklight::SolrHelper

  def show
    @response, @document = get_solr_response_for_doc_id
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
    send_file "tmp/downloads/#{params[:id]}.#{params[:format]}", type: 'application/zip', x_sendfile: true
  end

  private

  def check_type
    case params[:type]
    when 'shapefile'
      response = ShapefileDownload.new(@document).get
    when 'kmz'
      response = KmzDownload.new(@document).get
    end
    response
  end

  def validate(response)
    if response.nil?
      flash[:danger] = t 'geoblacklight.download.error'
    else
      flash[:success] = view_context.link_to(t('geoblacklight.download.success', title: response), download_file_path(response))
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
