require 'spec_helper'

describe Geoblacklight::ControllerOverride do
  class GeoblacklightControllerTestClass
  end
  
  before(:each) do
    @fake_controller = GeoblacklightControllerTestClass.new
    @fake_controller.extend(Geoblacklight::ControllerOverride)
  end
  
  let(:solr_params) { OpenStruct.new }
  let(:req_params) { OpenStruct.new }
  
  describe 'add_spatial_params' do
    it 'should return the solr_params when no bbox is given' do
      expect(@fake_controller.add_spatial_params(solr_params, req_params)).to eq solr_params
    end
    it 'should return a spatial search if bbox is given' do
      req_params.bbox = '123'
      expect(has_spatial_query(solr_params, req_params)).to be_truthy
    end
  end
end

def has_spatial_query(solr_params, req_params)
  /Intersects/ =~ @fake_controller.add_spatial_params(solr_params, req_params).fq.first
end