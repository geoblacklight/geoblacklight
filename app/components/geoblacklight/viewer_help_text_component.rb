# frozen_string_literal: true

module Geoblacklight
  ##
  # A component for rendering the help text for the viewer container
  #
  class ViewerHelpTextComponent < ViewComponent::Base
    def initialize(feature, key)
      @feature = feature
      @key = key
      super
    end

    # Retrieve i18n value
    def help_text_exists?
      I18n.exists?("geoblacklight.help_text.#{@feature}.#{@key}", locale)
    end

    def help_text_value
      I18n.t("geoblacklight.help_text.#{@feature}.#{@key}")
    end

    def help_text_tag
      help_text = help_text_value
      tag.h2 class: "help-text viewer_protocol h6" do
        tag.a data: {bs_toggle: "popover", bs_title: help_text[:title], bs_content: help_text[:content]} do
          help_text[:title]
        end
      end
    end

    def help_text_missing_tag
      tag.span class: "help-text translation-missing"
    end

    def display_text
      return help_text_tag if help_text_exists?

      help_text_missing_tag
    end

    def render?
      Settings&.HELP_TEXT&.public_send(@feature)&.include?(@key)
    end
  end
end
