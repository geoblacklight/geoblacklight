module Geoblacklight
  class Configuration
    # Shared behavior for the small ActiveModel value objects that are built by
    # mass-assigning a section of config/settings.yml -- RelationshipConfig and
    # DisplayNoteShownConfig.
    #
    # Because config/settings.yml is only written when GeoBlacklight is first
    # installed, an upgrading application's copy is whatever the installer wrote
    # years ago. Assigning that hash directly onto an ActiveModel raises
    # ActiveModel::UnknownAttributeError, naming a class the maintainer has never
    # heard of, for a key they did not choose. This module makes three changes:
    #
    # * keys are matched case-insensitively, so an uppercase +FIELD:+ resolves the
    #   same way the section name itself does (see CaseInsensitiveSettings)
    # * attributes named in +removed_attributes+ are dropped with one deprecation
    #   warning each, rather than raising
    # * anything else still raises, but with a message that names the file to edit
    #   and lists the keys that are accepted
    #
    # Include it *after* ActiveModel::Model and ActiveModel::Attributes:
    #
    #   class RelationshipConfig
    #     include ActiveModel::Model
    #     include ActiveModel::Attributes
    #     include SettingsAttributes
    #
    #     self.removed_attributes = %w[icon].freeze
    #     self.settings_section = "RELATIONSHIPS_SHOWN"
    #   end
    #
    # The ordering matters and fails silently if you get it wrong. This module
    # overrides ActiveModel::AttributeAssignment#attribute_writer_missing, so
    # ActiveModel has to be lower in the ancestor chain. Rewriting this as an
    # ActiveSupport::Concern that includes ActiveModel from its +included+ block
    # would put ActiveModel *ahead* of this module, and its raising default would
    # win with no error to say so.
    module SettingsAttributes
      def self.included(klass)
        # Attribute names (as strings) that this version of GeoBlacklight no longer
        # has any use for, but which an older config/settings.yml may still set.
        klass.class_attribute :removed_attributes, instance_writer: false, default: [].freeze

        # The config/settings.yml section this object is built from, used in messages.
        klass.class_attribute :settings_section, instance_writer: false

        klass.extend ClassMethods
      end

      module ClassMethods
        # Warns at most once per removed attribute per process. The whole
        # configuration is built once and memoized on Geoblacklight, and the fix is
        # "edit config/settings.yml", so one line per key is all you need to see.
        def warn_removed_attribute(name)
          @warned_removed_attributes ||= Set.new
          return unless @warned_removed_attributes.add?(name)

          Geoblacklight::Deprecation.warn(
            "config/settings.yml sets #{name} on a #{settings_section} entry. GeoBlacklight no " \
            "longer reads it and the line can be deleted; support for it will be removed in a " \
            "future version."
          )
        end

        # Lets a spec assert on the warning more than once.
        def reset_removed_attribute_warnings!
          @warned_removed_attributes = nil
        end
      end

      # ActiveModel calls this instead of raising when #assign_attributes is handed
      # a key with no matching setter.
      def attribute_writer_missing(name, value)
        key = name.to_s.downcase

        return public_send(:"#{key}=", value) if self.class.attribute_names.include?(key)
        return self.class.warn_removed_attribute(key) if self.class.removed_attributes.include?(key)

        raise Geoblacklight::Exceptions::InvalidSettings,
          "config/settings.yml: a #{self.class.settings_section} entry sets #{name.to_s.inspect}, " \
          "which GeoBlacklight does not recognize. It accepts only " \
          "#{self.class.attribute_names.join(", ")}."
      end
    end
  end
end
