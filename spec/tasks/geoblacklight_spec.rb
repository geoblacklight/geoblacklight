# frozen_string_literal: true
require 'spec_helper'
require 'rake'
require 'fileutils'

describe 'geoblacklight.rake' do
  describe 'geoblacklight:downloads:mkdir' do
    before do
      Rails.application.load_tasks
      FileUtils.rm_rf Rails.root.join('tmp', 'cache', 'downloads')
    end

    it 'creates the tmp/cache/downloads directory' do
      Rake::Task['geoblacklight:downloads:mkdir'].invoke
      expect(File.directory?(Rails.root.join('tmp', 'cache', 'downloads')))
        .to be true
    end
  end
end
