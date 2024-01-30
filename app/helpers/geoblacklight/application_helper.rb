module Geoblacklight
  module ApplicationHelper
    # Override: Returns the engine assets manifest.
    def vite_manifest
      Geoblacklight::Engine.vite_ruby.manifest
    end
  end
end
