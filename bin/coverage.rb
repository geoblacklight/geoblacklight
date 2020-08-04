# frozen_string_literal: true
# Borrowed from https://github.com/pulibrary/figgy/blob/master/scripts/combine_coverage.rb
require 'active_support/inflector'
require 'simplecov'

class SimpleCovHelper
  def self.report_coverage(base_dir: './coverage_results')
    min_cov = ENV['MINIMUM_COVERAGE'] || 100
    SimpleCov.configure do
      minimum_coverage(min_cov.to_i)
    end
    new(base_dir: base_dir).merge_results
  end

  attr_reader :base_dir

  def initialize(base_dir:)
    @base_dir = base_dir
  end

  def all_results
    Dir["#{base_dir}/.resultset*.json"]
  end

  def merge_results
    results = all_results.map { |file| SimpleCov::Result.from_hash(JSON.parse(File.read(file))) }
    results = SimpleCov::ResultMerger.merge_results(*results)
    results.format!
    covered_percent = results.covered_percent.round(2)
    return unless covered_percent < SimpleCov.minimum_coverage[:line]
    $stderr.printf("Coverage (%.2f%%) is below the expected minimum coverage (%.2f%%).\n", covered_percent, SimpleCov.minimum_coverage[:line])
    Kernel.exit SimpleCov::ExitCodes::MINIMUM_COVERAGE
  end
end

SimpleCovHelper.report_coverage
