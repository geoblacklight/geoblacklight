module Geoblacklight
  class Configuration
    # Configuration for an individual relationship displayed on a document's show page.
    class RelationshipConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :field, :string
      attribute :icon, :string
      attribute :inverse, :string
      attribute :label, :string
      attribute :query_type, :string
    end
  end
end
