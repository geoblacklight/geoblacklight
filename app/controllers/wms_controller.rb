class WmsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def handle
    response = Geoblacklight::WmsLayer.new(wms_params).feature_info

    respond_to do |format|
      format.json { render json: response }
    end
  end

  private

  def wms_params
    params.permit('URL', 'LAYERS', 'BBOX', 'WIDTH', 'HEIGHT', 'QUERY_LAYERS', 'X', 'Y')
  end
end
