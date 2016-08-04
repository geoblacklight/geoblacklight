class RelationController < ApplicationController
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  copy_blacklight_config_from(CatalogController)

  def relations
    @relation_response = Geoblacklight::Relation::RelationResponse.new(params[:id], repository)
    respond_to do |format|
      format.json do
        render json: @relation_response.relations
      end
      format.html do
        render 'catalog/relations', layout: false
      end
    end
  end
end
