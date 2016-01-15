class WmsController < ApplicationController
  def handle
    response = Geoblacklight::WmsLayer.new(params).feature_info

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
