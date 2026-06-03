module Geoblacklight
  class Configuration
    # Configuration for display note shown.
    class DisplayNoteShownConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :bootstrap_alert_class, :string
      attribute :icon, :string
      attribute :note_prefix, :string
    end
  end
end
