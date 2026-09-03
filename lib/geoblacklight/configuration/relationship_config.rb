module Geoblacklight
  class Configuration
    # Configuration for an individual relationship displayed on a document's show page.
    class RelationshipConfig
      include ActiveModel::Model
      include ActiveModel::Attributes
      include SettingsAttributes

      # GeoBlacklight 5 drew a per-relationship icon next to each related record.
      # GeoBlacklight 6 labels them with a resource-class badge instead, but every
      # config/settings.yml generated since 4.0 still sets this.
      self.removed_attributes = %w[icon].freeze
      self.settings_section = "RELATIONSHIPS_SHOWN"

      attribute :field, :string
      attribute :inverse, :string
      attribute :label, :string
      attribute :query_type, :string
    end
  end
end
