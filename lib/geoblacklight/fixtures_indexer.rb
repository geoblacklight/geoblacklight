require "#{Rails.root}/spec/fixtures/geoblacklight_schema"

class FixturesIndexer
  def self.run
    FixturesIndexer.new.run
  end
  def initialize
    @solr = Blacklight.solr
  end
  def run
    index
    commit
  end
  def fixtures
    @fixtures ||= JSON::parse(File.read("#{Rails.root}/spec/fixtures/geoblacklight_schema/transformed.json"))
    # @fixtures ||= file_list.map do |file|
    #   fixture_template = ERB.new(File.read(file))
    #   rendered_template = fixture_template.result(binding)
    #   YAML::load rendered_template
    # end
  end
  def file_list
    # data = JSON::parse(File.read("#{Rails.root}/spec/fixtures/geoblacklight_schema/transformed.json"))
    # @file_list ||= Dir["#{Rails.root}/spec/fixtures/solr_documents/*.yml"]
  end

  private
  def index
    @solr.add fixtures
  end
  def commit
    @solr.commit
  end
end
