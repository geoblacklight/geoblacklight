class DownloadController < ApplicationController
  include Blacklight::SolrHelper

  def show
    @response, @document = get_solr_response_for_doc_id
    response = check_type
    validate response
    respond_to do |format|
      format.json { render json: flash, response: response }
      format.html { render json: flash, response: response }
    end
  end

  def file
    send_file "tmp/cache/downloads/#{params[:id]}.#{params[:format]}", type: 'application/zip', x_sendfile: true
  end

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
end
