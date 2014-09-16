require 'spec_helper'

describe Geoblacklight::ViewHelperOverride do
  class GeoblacklightControllerTestClass
    attr_accessor :params
  end
  
  before(:each) do
    @fake_controller = GeoblacklightControllerTestClass.new
    @fake_controller.extend(Geoblacklight::ViewHelperOverride)
  end
  
  describe 'has_spatial_parameters?' do
    it 'should not have spatial parameters' do
      @fake_controller.params = {}
      expect(@fake_controller.has_spatial_parameters?).to be_falsey
    end
    it 'should have spatial parameters' do
      @fake_controller.params = { bbox: '123'}
      expect(@fake_controller.has_spatial_parameters?).to be_truthy
    end
  end
end