# frozen_string_literal: true

module Geoblacklight
  class DisplayNoteComponent < ViewComponent::Base
    include Blacklight::IconHelperBehavior

    def initialize(display_note:)
      @display_note = display_note
      super()
    end

    def before_render
      @display_note = decorated_note
      super
    end

    private

    def decorated_note
      @note = ""
      prefixed = false
      prefixes.each do |prefix, value|
        if @display_note.include?(prefix)
          prefixed = true
          @note = tag.div class: "gbl-display-note alert #{value.first}", role: "alert" do
            capture do
              "#{helpers.geoblacklight_icon(value.second)}
              #{@display_note}".html_safe
            end
          end
        end
      end

      if prefixed == false
        @note = tag.div class: "gbl-display-note alert alert-secondary", role: "alert" do
          @display_note
        end
      end

      @note
    end

    def prefixes
      Settings.DISPLAY_NOTES_SHOWN.map { |key, value| [value.note_prefix, [value.bootstrap_alert_class, value.icon]] }.to_h
    end
  end
end
