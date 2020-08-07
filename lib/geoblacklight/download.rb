# frozen_string_literal: true
module Geoblacklight
  class Download
    def initialize(document, options = {})
      @document = document
      @options = options
    end

    def downloadable?
      @document.downloadable?
    end

    def file_name
      "#{@document.id}-#{@options[:type]}.#{@options[:extension]}"
    end

    def self.file_path
      Settings.DOWNLOAD_PATH || Rails.root.join('tmp', 'cache', 'downloads')
    end

    def file_path_and_name
      "#{self.class.file_path}/#{file_name}"
    end

    def download_exists?
      File.file?(file_path_and_name)
    end

    def get
      if download_exists?
        file_name
      else
        create_download_file
      end
    end

    ##
    # Creates temporary file on file system and renames it if download completes
    # successfully. Will raise and rescue if the wrong file format is downloaded
    # @return [String] filename of the completed download
    def create_download_file
      download = initiate_download

      File.open("#{file_path_and_name}.tmp", 'wb') do |file|
        fail Geoblacklight::Exceptions::WrongDownloadFormat unless matches_mimetype?(download)
        file.write download.body
      end
      File.rename("#{file_path_and_name}.tmp", file_path_and_name)
      file_name
    rescue Geoblacklight::Exceptions::WrongDownloadFormat => error
      Geoblacklight.logger.error "#{error} expected #{@options[:content_type]} "\
                                 "received #{download.headers['content-type']}"
      File.delete("#{file_path_and_name}.tmp")
      raise Geoblacklight::Exceptions::ExternalDownloadFailed, message: 'Wrong download type'
    end

    ##
    # Initiates download from a remote source url using the `request_params`.
    # Will catch Faraday::ConnectionFailed and
    # Faraday::TimeoutError
    # @return [Faraday::Request] returns a Faraday::Request object
    def initiate_download
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = @options[:request_params]
        request.options.timeout = timeout
        request.options.open_timeout = timeout
      end
    rescue Faraday::ConnectionFailed
      raise Geoblacklight::Exceptions::ExternalDownloadFailed,
            message: 'Download connection failed',
            url: conn.url_prefix.to_s
    rescue Faraday::TimeoutError
      raise Geoblacklight::Exceptions::ExternalDownloadFailed,
            message: 'Download timed out',
            url: conn.url_prefix.to_s
    end

    ##
    # Creates a download url for the object
    # @return [String]
    def url_with_params
      url + '/?' + URI.encode_www_form(@options[:request_params])
    end

    private

    def matches_mimetype?(download)
      MIME::Type.simplified(download.headers['content-type']) == @options[:content_type]
    end

    ##
    # Returns timeout for the download request. `timeout` passed as an option to
    # the Geoblacklight::Download class
    # @return [Fixnum] download timeout in seconds
    def timeout
      @options[:timeout] || Settings.TIMEOUT_DOWNLOAD || 20
    end

    ##
    # URL for download
    # @return [String] URL that is checked in download
    def url
      url = @document.references.send(@options[:service_type]).endpoint
      url += '/reflect' if @options[:reflect]
      url
    end
  end
end
