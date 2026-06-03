module Geoblacklight
  class Configuration
    class LeafletSleepConfig
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :sleep, :boolean, default: true # set to false to disable
      attribute :margin_distance, :integer, default: 100 # set to zero / false if you want to disable this check
      attribute :sleeptime, :integer, default: 750
      attribute :waketime, :integer, default: 750
      attribute :hovertowake, :boolean, default: false
      attribute :message, :string, default: "Click to Wake"
      attribute :background, :string, default: "rgba(214, 214, 214, .7)"

      def to_h
        attributes
      end
    end
  end
end
