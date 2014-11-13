require 'spec_helper'

describe Geoblacklight::SolrDocument do
  let(:document) { SolrDocument.new(document_attributes) }
  describe '#available?' do
    let(:document_attributes) { {} }
    describe 'a public document' do
      it 'should always be available' do
        allow(document).to receive('same_institution?').and_return(false)
        allow(document).to receive('public?').and_return(true)
        expect(document.available?).to be_truthy
      end
    end
    describe 'a restricted document' do
      describe 'should only be available if from same institution' do
        allow(document).to receive('same_institution?').and_return(true)
        allow(document).to receive('public?').and_return(false)
        expect(document.available?).to be_truthy
      end
    end
  end
  describe '#public?' do
    describe 'a public document' do
      let(:document_attributes) { { dc_rights_s: 'PUBLIC' } }
      it 'should be public' do
        expect(document.public?).to be_truthy
      end
    end
    describe 'a restricted resource' do
      let(:document_attributes) { { dc_rights_s: 'RESTRICTED' } }
      it 'should not be public' do
        expect(document.public?).to be_falsey
      end
    end
  end
  describe '#same_institution?' do
    describe 'within the same institution' do
      let(:document_attributes) { { dct_provenance_s: 'STANFORD' } }
      it 'should be true' do
        allow(Settings).to receive('Institution').and_return('Stanford')
        expect(document.same_institution?).to be_truthy
      end
      it 'should match case inconsistencies' do
        allow(Settings).to receive('Institution').and_return('StAnFord')
        expect(document.same_institution).to be_truthy
      end
    end
    describe 'within a different institution' do
      let(:document_attributes) { { dct_provenance_s: 'MIT' } }
      it 'should be false' do
        allow(Settings).to receive('Institution').and_return('Stanford')
        expect(document.same_institution?).to be_falsey
      end
    end
  end
end
