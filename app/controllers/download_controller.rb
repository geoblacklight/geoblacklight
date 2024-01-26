# frozen_string_literal: true

class DownloadController < ApplicationController
  # include Blacklight::SearchHelper
  include Blacklight::Catalog

  rescue_from Geoblacklight::Exceptions::ExternalDownloadFailed do |exception|
    Geoblacklight.logger.error exception.message + " " + exception.url
    flash[:danger] = view_context
      .tag.span(t("geoblacklight.download.error"),
        data: {
          download: "error",
          download_id: params[:id],
          download_type: "generated-#{params[:type]}"
        })
    respond_to do |format|
      format.json { render json: flash, response: response }
      format.html { render json: flash, response: response }
    end
  end

  def show
    @response, @document = search_service.fetch params[:id]
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
    @response, @document = search_service.fetch(file_name_to_id(params[:id]))
    restricted_should_authenticate
    send_file download_file_path_and_name, x_sendfile: true
  end

  def hgl
    @response, @document = search_service.fetch params[:id]
    if params[:email]
      response = Geoblacklight::HglDownload.new(@document, params[:email]).get
      if response.nil?
        flash[:danger] = t "geoblacklight.download.error"
      else
        flash[:success] = t "geoblacklight.download.hgl_success"
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

  def download_file_path_and_name
    "#{Geoblacklight::Download.file_path}/#{params[:id]}.#{params[:format]}"
  end

  def check_type
    case params[:type]
    when "shapefile"
      Geoblacklight::ShapefileDownload.new(@document).get
    when "kmz"
      Geoblacklight::KmzDownload.new(@document).get
    when "geojson"
      Geoblacklight::GeojsonDownload.new(@document).get
    when "geotiff"
      Geoblacklight::GeotiffDownload.new(@document).get
    end
  end

  def validate(response)
    flash[:success] = view_context.link_to(t("geoblacklight.download.success", title: response),
      download_file_path(response),
      data: {download: "trigger",
             download_id: params[:id],
             download_type: "generated-#{params[:type]}"})
  end

  # Checks whether a document is public, if not require user to authenticate
  def restricted_should_authenticate
    authenticate_user! unless @document.public?
  end

  def file_name_to_id(file_name)
    file_name.split("-")[0..-2].join("-")
  end
end
