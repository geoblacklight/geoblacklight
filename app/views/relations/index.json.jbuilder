# frozen_string_literal: true

json.current_doc @relations.link_id
json.relations do
  Geoblacklight.configuration.relationships_shown.each do |key, _value|
    results = @relations.public_send(key)
    json.set! key.downcase.to_s, results unless results["numFound"].to_i.zero?
  end
end
