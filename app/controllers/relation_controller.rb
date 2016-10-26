class RelationController < ApplicationController
  include Blacklight::Configurable
  include Blacklight::SearchHelper
  copy_blacklight_config_from(CatalogController)

  def index
    @relations = Geoblacklight::Relation::RelationResponse.new(params[:id], repository)
    render layout: !request.xhr?
  end
end
