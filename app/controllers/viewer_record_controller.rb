# frozen_string_literal: true

# Serves the version of the Solr document that is used by viewers.
class ViewerRecordController < ApplicationController
  include Blacklight::Configurable

  copy_blacklight_config_from(CatalogController)

  rescue_from Blacklight::Exceptions::RecordNotFound do
    head :not_found
  end

  def show
    render json: Geoblacklight::ViewerRecord.new(document, available: helpers.document_available?(document))
  end

  private

  def document
    @document ||= repository.find(params[:id]).documents.first
  end

  def repository
    @repository ||= blacklight_config.repository_class.new(blacklight_config)
  end
end
