# frozen_string_literal: true

require "spec_helper"

describe GeoblacklightHelper, type: :helper do
  include BlacklightHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper

  describe "#geoblacklight_icon" do
    it "supports in use cases" do
      {
        "Paper map" => "paper-map",
        "Michigan State" => "michigan-state",
        "CD ROM" => "cd-rom",
        "Lewis & Clark" => "lewis-clark"
      }.each_key do |key|
        html = Capybara.string(geoblacklight_icon(key))
        expect(html).to have_xpath "//*[local-name() = 'svg']"
      end
    end
    it "handles nil values" do
      html = Capybara.string(geoblacklight_icon(nil))
      expect(html).to have_css ".icon-missing"
    end
  end

  describe "#proper_case_format" do
    it "returns a properly cased format" do
      expect(proper_case_format("GEOJSON")).to eq "GeoJSON"
    end
  end

  describe "#download_text" do
    it "returns download text concatenated with proper case format" do
      expect(download_text("GEOJSON")).to eq "Original GeoJSON"
    end
  end

  describe "#download_text" do
    it "returns download text concatenated with proper case format" do
      expect(download_text("GEOJSON")).to eq "Original GeoJSON"
    end
  end

  describe "#download_link_file" do
    let(:label) { "Test Link Text" }
    let(:id) { "test-id" }
    let(:url) { "http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip" }

    it "generates a link to download the original file" do
      expect(download_link_file(label, id, url)).to eq '<a contentUrl="http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip" data-download="trigger" data-download-type="direct" data-download-id="test-id" href="http://example.com/urn:hul.harvard.edu:HARVARD.SDE2.TG10USAIANNH/data.zip">Test Link Text</a>'
    end
  end

  describe "#download_link_hgl" do
    let(:text) { "Test Link Text" }
    let(:document) { instance_double(SolrDocument) }

    before do
      allow(document).to receive(:id).and_return("test-id")
      allow(document).to receive(:to_s).and_return("test-id")
    end

    it "generates a link to the HGL route" do
      expect(download_link_hgl(text, document)).to eq '<a data-blacklight-modal="trigger" data-download="trigger" data-download-type="harvard-hgl" data-download-id="test-id" href="/download/hgl/test-id">Test Link Text</a>'
    end
  end

  describe "#download_link_iiif" do
    let(:references_field) { Settings.FIELDS.REFERENCES }
    let(:document_attributes) do
      {
        references_field => {
          "http://iiif.io/api/image" => "https://example.edu/image/info.json"
        }.to_json
      }
    end
    let(:document) { SolrDocument.new(document_attributes) }

    before do
      allow_any_instance_of(Geoblacklight::Reference).to receive(:to_hash).and_return(iiif: "https://example.edu/image/info.json")
    end

    it "generates a link to download the JPG file from the IIIF server" do
      assign(:document, document)
      expect(helper.download_link_iiif).to eq '<a contentUrl="https://example.edu/image/full/full/0/default.jpg" data-download="trigger" href="https://example.edu/image/full/full/0/default.jpg">Original JPG</a>'
    end
  end

  describe "#download_link_generated" do
    let(:download_type) { "SHAPEFILE" }
    let(:document) { instance_double(SolrDocument) }

    before do
      allow(document).to receive(:id).and_return("test-id")
      allow(document).to receive(:to_s).and_return("test-id")
    end

    it "generates a link to download the JPG file from the IIIF server" do
      # Stub I18n to ensure the link can be customized via `export_` labels.
      allow(helper).to receive(:t).and_call_original
      allow(helper).to receive(:t).with("geoblacklight.download.export_shapefile_link").and_return("Shapefile Export Customization")
      expect(helper.download_link_generated(download_type, document)).to eq '<a data-download-path="/download/test-id?type=SHAPEFILE" data-download="trigger" data-download-type="SHAPEFILE" data-download-id="test-id" href="">Export Shapefile Export Customization</a>'
    end
  end

  describe "#geoblacklight_basemap" do
    let(:blacklight_config) { double }
    it "without configuration" do
      expect(blacklight_config).to receive(:basemap_provider).and_return(nil)
      expect(geoblacklight_basemap).to eq "positron"
    end
    it "with custom configuration" do
      expect(blacklight_config).to receive(:basemap_provider).and_return("positron")
      expect(geoblacklight_basemap).to eq "positron"
    end
  end

  describe "#iiif_jpg_url" do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    let(:document_attributes) do
      {
        references_field => {
          "http://iiif.io/api/image" => "https://example.edu/image/info.json"
        }.to_json
      }
    end

    it "returns JPG download URL when given URL to a IIIF info.json" do
      assign(:document, document)
      expect(helper.iiif_jpg_url).to eq "https://example.edu/image/full/full/0/default.jpg"
    end
  end

  describe "#snippit" do
    let(:document) { SolrDocument.new(document_attributes) }
    let(:references_field) { Settings.FIELDS.REFERENCES }
    context "as a String" do
      let(:document_attributes) do
        {
          value: "This is a really long string that should get truncated when it gets rendered" \
                 "in the index view to give a brief description of the contents of a particular document" \
                 "indexed into Solr"
        }
      end
      it "truncates longer strings to 150 characters" do
        expect(helper.snippit(document).length).to eq 150
      end
      it "truncated string ends with ..." do
        expect(helper.snippit(document)[-3..]).to eq "..."
      end
    end
    context "as an Array" do
      let(:document_attributes) do
        {
          value: ["This is a really long string that should get truncated when it gets rendered" \
                  "in the index view to give a brief description of the contents of a particular document" \
                  "indexed into Solr"]
        }
      end
      it "truncates longer strings to 150 characters" do
        expect(helper.snippit(document).length).to eq 150
      end
      it "truncated string ends with ..." do
        expect(helper.snippit(document)[-3..]).to eq "..."
      end
    end
    context "as a multivalued Array" do
      let(:document_attributes) do
        {
          value: %w[short description]
        }
      end
      it "uses both values" do
        expect(helper.snippit(document)).to eq "short description"
      end
      it "does not truncate" do
        expect(helper.snippit(document)[-3..]).not_to eq "..."
      end
    end
  end

  describe "#leaflet_options" do
    it "returns a hash of options for leaflet" do
      expect(leaflet_options[:VIEWERS][:WMS][:CONTROLS]).to eq(%w[Opacity Fullscreen])
    end
  end

  describe "#render_value_as_truncate_abstract" do
    context "with multiple values" do
      let(:document) { SolrDocument.new(value: %w[short description]) }
      it "wraps in correct DIV class" do
        expect(helper.render_value_as_truncate_abstract(document)).to eq '<div class="truncate-abstract">short description</div>'
      end
    end
  end

  describe "#render_transformed_metadata" do
    let(:metadata) { instance_double(Geoblacklight::Metadata::Base) }
    context "with valid XML data" do
      before do
        allow(metadata).to receive(:transform).and_return("<div>test</div>")
      end

      it "renders the partial with metadata content" do
        expect(helper).to receive(:render)
          .with(partial: "catalog/metadata/content", locals: {content: "<div>test</div>"})
        helper.render_transformed_metadata(metadata)
      end
    end

    context "with valid XML data without an HTML transform" do
      before do
        allow(metadata).to receive(:transform).and_raise(Geoblacklight::MetadataTransformer::TransformError)
        allow(metadata).to receive(:to_xml).and_return("<data></data>")
      end

      it "renders the partial with metadata content" do
        expect(helper).to receive(:render).with(partial: "catalog/metadata/markup", locals: {content: "<data></data>"})
        helper.render_transformed_metadata(metadata)
      end
    end

    context "without XML data" do
      before do
        allow(metadata).to receive(:transform).and_raise(Geoblacklight::MetadataTransformer::ParseError)
      end

      it "renders the partial with metadata content" do
        expect(helper).to receive(:render).with(partial: "catalog/metadata/missing")
        helper.render_transformed_metadata(metadata)
      end
    end
  end

  describe "#first_metadata?" do
    let(:metadata) { instance_double(Geoblacklight::Metadata::Base) }
    let(:references) { instance_double(Geoblacklight::References) }
    let(:document) { instance_double(SolrDocument) }

    before do
      allow(document).to receive(:references).and_return(references)
      allow(references).to receive(:shown_metadata).and_return([metadata])
      allow(metadata).to receive(:type).and_return("fgdc")
    end

    it "confirms that a metadata resource is the first item reference" do
      expect(helper.first_metadata?(document, metadata)).to be true
    end
  end

  describe "#show_help_text?" do
    let(:feature) { "viewer_protocol" }
    let(:translation_key) { "wms" }

    it "confirms help text is available" do
      expect(helper.show_help_text?(feature, translation_key)).to be true
    end
  end

  describe "#render_help_text_entry" do
    let(:feature) { "viewer_protocol" }
    let(:translation_key) { "wms" }

    context "valid entry" do
      it "renders help text entry for the wms viewer protocol" do
        expect(helper.render_help_text_entry(feature, translation_key)).to eq '<h2 class="help-text viewer_protocol h6"><a data-toggle="popover" data-title="Web Map Service (WMS)" data-content="A Web Map Service displays a geospatial dataset as map images.">Web Map Service (WMS)</a></h2>'
      end
    end

    context "invalid entry" do
      it "renders an empty span" do
        expect(helper.render_help_text_entry("foo", "bar")).to eq '<span class="help-text translation-missing"></span>'
      end
    end
  end

  describe "#relations_icon" do
    context "when configured to use the geometry type" do
      before do
        allow(Settings).to receive(:USE_GEOM_FOR_RELATIONS_ICON).and_return(true)
      end

      it "renders a goemetry type as the icon" do
        html = Capybara.string(helper.relations_icon({Settings.FIELDS.GEOM_TYPE => "polygon"}, "leaf"))
        expect(html.title.strip).to eq "Polygon"
      end

      it "has the svg_tooltip class so that the Bootstrap tooltip is applied" do
        html = Capybara.string(helper.relations_icon({Settings.FIELDS.GEOM_TYPE => "polygon"}, "leaf"))
        expect(html).to have_css(".blacklight-icons.svg_tooltip")
      end
    end

    context "when not confiugred to use the geometry type" do
      before do
        allow(Settings).to receive(:USE_GEOM_FOR_RELATIONS_ICON).and_return(false)
      end

      it "renders the provided icon" do
        html = Capybara.string(helper.relations_icon({Settings.FIELDS.GEOM_TYPE => "polygon"}, "leaf"))
        expect(html.title.strip).to eq "Leaf"
      end

      it "does not have the svg_tooltip class" do
        html = Capybara.string(helper.relations_icon({Settings.FIELDS.GEOM_TYPE => "polygon"}, "leaf"))
        expect(html).not_to have_css(".blacklight-icons.svg_tooltip")
      end
    end
  end

  describe "#results_js_map_selector" do
    context "viewing bookmarks" do
      let(:controller_name) { "bookmarks" }

      it "returns bookmarks data-map selector" do
        expect(results_js_map_selector(controller_name)).to eq "bookmarks"
      end
    end

    context "viewing catalog results" do
      let(:controller_name) { "catalog" }

      it "returns index data-map selector" do
        expect(results_js_map_selector(controller_name)).to eq "index"
      end
    end

    context "calling outside of intended scope" do
      let(:controller_name) { "outside" }

      it "returns default data-map value" do
        expect(results_js_map_selector(controller_name)).to eq "index"
      end
    end
  end
end
