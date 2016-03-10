require 'spec_helper'

describe Geoblacklight::FeatureInfoResponse do
  let(:response) { described_class.new(OpenStruct.new(body: '<html><body><table><th>Header1</th><th>Header2</th><td>value1</td><td>value2</td></body></html>', headers: { 'content-type' => 'all good' })) }
  let(:error_response) { described_class.new(error: 'bad stuff') }
  let(:content_response) { described_class.new(OpenStruct.new(headers: { 'content-type' => 'text/xml' })) }

  describe '#initialize' do
    it 'initializes as a FeatureInfoResponse type' do
      expect(response).to be_an described_class
    end
  end

  describe '#error?' do
    it 'if no error' do
      expect(response.error?).to be_falsey
    end
    it 'if error key is present' do
      expect(error_response.error?).to be_truthy
    end
    it 'if content-type header is text/xml' do
      expect(content_response.error?).to be_truthy
    end
  end

  describe '#format' do
    it 'returns a formated response' do
      expect(response.format).not_to be_nil
      expect(response.format[:values].length).to eq 2
      expect(response.format[:values][0]).to eq %w(Header1 value1)
      expect(response.format[:values][1]).to eq %w(Header2 value2)
    end
  end

  describe '#check' do
    it 'returns a formated response if no errors' do
      expect(response.check).to eq response.format
    end
    it 'returns the unformated response if there are errors' do
      expect(error_response.check).to eq error_response.instance_variable_get('@response')
    end
  end
end
