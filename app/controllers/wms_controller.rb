class WmsController < ApplicationController
  def handle
    response = WmsLayer.new(params).get_feature_info

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
