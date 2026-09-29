# frozen_string_literal: true

class RelationsController < ApplicationController
  include Blacklight::Configurable

  copy_blacklight_config_from(CatalogController)

  allow_unauthenticated_access raise: false if respond_to?(:allow_unauthenticated_access)

  def index
    @relations = Geoblacklight::Relations::RelationResponse.new(params[:id], repository)
    render layout: !(request.xhr? || request.headers["Turbo-Frame"].present?)
  end

  private

  def repository_class
    blacklight_config.repository_class
  end

  def repository
    @repository ||= repository_class.new(blacklight_config)
  end
end
