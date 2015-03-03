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
      "#{@document[:layer_slug_s]}-#{@options[:type]}.#{@options[:extension]}"
    end

    def file_path
      "#{Rails.root}/tmp/cache/downloads/#{file_name}"
    end

    def download_exists?
      File.file?(file_path)
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
      File.open("#{file_path}.tmp", 'wb')  do |file|
        if download.headers['content-type'] == @options[:content_type]
          file.write download.body
        else
          fail Geoblacklight::Exceptions::WrongDownloadFormat
        end
      end
      File.rename("#{file_path}.tmp", file_path)
      file_name
    rescue Geoblacklight::Exceptions::WrongDownloadFormat => error
      Geoblacklight.logger.error "#{error} expected #{@options[:content_type]} received #{download.headers['content-type']}"
      File.delete("#{file_path}.tmp")
      raise Geoblacklight::Exceptions::ExternalDownloadFailed, message: 'Wrong download type'
    end

    ##
    # Initiates download from a remote source url using the `request_params`.
    # Will catch Faraday::Error::ConnectionFailed and
    # Faraday::Error::TimeoutError 
    # @return [Faraday::Request] returns a Faraday::Request object
    def initiate_download
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = @options[:request_params]
        request.options = {
          timeout: timeout,
          open_timeout: timeout
        }
      end
    rescue Faraday::Error::ConnectionFailed => error
      raise Geoblacklight::Exceptions::ExternalDownloadFailed, message: 'Download connection failed', url: conn.url_prefix.to_s
    rescue Faraday::Error::TimeoutError => error
      raise Geoblacklight::Exceptions::ExternalDownloadFailed, message: 'Download timed out', url: conn.url_prefix.to_s
    end

    private

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
