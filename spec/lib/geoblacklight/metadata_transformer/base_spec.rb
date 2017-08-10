require 'spec_helper'

describe Geoblacklight::MetadataTransformer::Base do
  describe '.new' do
    it 'raises an error for empty XML' do
      expect { described_class.new(nil) }.to raise_error Geoblacklight::MetadataTransformer::EmptyMetadataError
    end
  end
end
