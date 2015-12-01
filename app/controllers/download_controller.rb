class DownloadController < ApplicationController
  include Blacklight::SearchHelper

  rescue_from Geoblacklight::Exceptions::ExternalDownloadFailed do |exception|
    Geoblacklight.logger.error exception.message + ' ' + exception.url
    flash[:danger] = view_context
                     .content_tag(:span,
                         flash_error_message(exception),
                         data: {
                           download: 'error',
                           download_id: params[:id],
                           download_type: "generated-#{params[:type]}"
                         })
    respond_to do |format|
      format.json { render json: flash, response: response }
      format.html { render json: flash, response: response }
    end
  end

  def show
    @response, @document = fetch params[:id]
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
    @response, @document = fetch(file_name_to_id(params[:id]))
    restricted_should_authenticate
    send_file download_file_path_and_name, type: 'application/zip', x_sendfile: true
  end

  def hgl
    @response, @document = fetch params[:id]
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

  protected

  ##
  # Creates an error flash message with failed download url
  # @param [Geoblacklight::Exceptions::ExternalDownloadFailed] Download failed
  # exception
  # @return [String] error message to display in flash 
  def flash_error_message(exception)
    if exception.url
      message = t('geoblacklight.download.error_with_url',
                  link: view_context
                        .link_to(exception.url,
                                 exception.url,
                                 target: 'blank'))
                .html_safe
    else
      message = t('geoblacklight.download.error')
    end
  end

  private

  def download_file_path_and_name
    "#{Geoblacklight::Download.file_path}/#{params[:id]}.#{params[:format]}"
  end

  def check_type
    response = case params[:type]
    when 'shapefile'
      Geoblacklight::ShapefileDownload.new(@document).get
    when 'kmz'
      Geoblacklight::KmzDownload.new(@document).get
    when 'geojson'
      Geoblacklight::GeojsonDownload.new(@document).get
    when 'geotiff'
      Geoblacklight::GeotiffDownload.new(@document).get
    when 'jpg'
      Geoblacklight::JpgDownload.new(@document).get
    end
  end

  def validate(response)
    flash[:success] = view_context.link_to(t('geoblacklight.download.success', title: response), download_file_path(response), data: {download: 'trigger', download_id: params[:id], download_type: "generated-#{params[:type]}"})
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
