module Geoblacklight
  # Determines whether references or dct_references_s is used
  class ReferenceFactory
    def self.determine(document)
      if document['references']
        DcatReferences.new(document)
      else
        References.new(document)
      end
    end
  end
end
