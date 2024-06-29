# frozen_string_literal: true

module Geoblacklight
  # Display expandable file download links in sidebar
  class RelationsComponent < ViewComponent::Base
    attr_reader :relations, :relationship_type, :rel_type_info

    def initialize(relations:, relationship_type:, rel_type_info:)
      @relations = relations
      @relationship_type = relationship_type
      @rel_type_info = rel_type_info
      super
    end

    def render?
      relations.send(relationship_type)["numFound"].to_i.positive?
    end
  end
end
