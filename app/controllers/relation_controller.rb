# frozen_string_literal: true
class RelationController < ApplicationController
  include Blacklight::Configurable
  # include Blacklight::SearchHelper
  copy_blacklight_config_from(CatalogController)

  def index
    @relations = Geoblacklight::Relation::RelationResponse.new(params[:id], repository)
    render layout: !request.xhr?
  end

  private

  def repository_class
    blacklight_config.repository_class
  end

  def repository
    @repository ||= repository_class.new(blacklight_config)
  end
end
