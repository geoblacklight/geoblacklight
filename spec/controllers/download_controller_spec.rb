# frozen_string_literal: true

require "spec_helper"

describe DownloadController, type: :controller do
  describe "#file" do
    describe "restricted file" do
      it "redirects to login for authentication" do
        get :file, params: {id: "stanford-cg357zz0321-shapefile", format: "zip"}
        expect(response).to have_http_status :unauthorized
      end
    end
    describe "public file" do
      it "initiates download" do
        allow(controller).to receive(:render) # Needed for testing with Rails 4
        expect(controller).to receive(:send_file)
        get :file, params: {id: "mit-f6rqs4ucovjk2-shapefile", format: "zip"}
      end
    end
  end
  describe "#show" do
    describe "restricted file" do
      it "redirects to login for authentication" do
        get :show, params: {id: "stanford-cg357zz0321", format: "json"}
        expect(response).to have_http_status :unauthorized
      end
    end
    describe "public file" do
      let(:shapefile_download) { instance_double(Geoblacklight::ShapefileDownload) }

      before do
        allow(Geoblacklight::ShapefileDownload).to receive(:new).and_return(shapefile_download)
      end

      it "initiates download creation" do
        allow(shapefile_download).to receive(:get).and_return("success")
        get :show, params: {id: "mit-f6rqs4ucovjk2", type: "shapefile"}
        expect(response).to have_http_status :ok
      end
    end

    context "when requesting GeoJSON files" do
      let(:id) { "tufts-cambridgegrid100-04" }
      let(:type) { "geojson" }
      let(:geojson_download) { instance_double(Geoblacklight::GeojsonDownload) }

      before do
        allow(geojson_download).to receive(:get).and_return("file.json")
        allow(Geoblacklight::GeojsonDownload).to receive(:new).and_return(geojson_download)
      end

      it "downloads the files and notifies the user" do
        expect(Geoblacklight::GeojsonDownload).to receive(:new)
        get :show, params: {id: id, type: type}

        expect(response.body).to include "success"
        expect(response.body).to include "Your file file.json is ready for download"
      end
    end

    context "when requesting GeoTIFF files" do
      let(:id) { "tufts-cambridgegrid100-04" }
      let(:type) { "geotiff" }
      let(:geotiff_download) { instance_double(Geoblacklight::GeotiffDownload) }

      before do
        allow(geotiff_download).to receive(:get).and_return("file.tiff")
        allow(Geoblacklight::GeotiffDownload).to receive(:new).and_return(geotiff_download)
      end

      it "downloads the files and notifies the user" do
        expect(Geoblacklight::GeotiffDownload).to receive(:new)
        get :show, params: {id: id, type: type}

        expect(response.body).to include "success"
        expect(response.body).to include "Your file file.tiff is ready for download"
      end
    end

    context "when requesting CSV files" do
      let(:id) { "tufts-cambridgegrid100-04" }
      let(:type) { "csv" }
      let(:csv_download) { instance_double(Geoblacklight::CsvDownload) }

      before do
        allow(csv_download).to receive(:get).and_return("file.csv")
        allow(Geoblacklight::CsvDownload).to receive(:new).and_return(csv_download)
      end

      it "downloads the files and notifies the user" do
        expect(Geoblacklight::CsvDownload).to receive(:new)
        get :show, params: {id: id, type: type}

        expect(response.body).to include "success"
        expect(response.body).to include "Your file file.csv is ready for download"
      end
    end
  end
end
