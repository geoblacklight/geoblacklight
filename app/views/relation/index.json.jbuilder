# frozen_string_literal: true

json.current_doc @relations.search_id
json.relations do
  Settings.RELATIONSHIPS_SHOWN.each do |key, _value|
    json.set! key.downcase.to_s, @relations.send(key) unless @relations.send(key)["numFound"].to_i.zero?
  end
end
