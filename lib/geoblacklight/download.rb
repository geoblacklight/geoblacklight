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

    def create_download_file
      download = initiate_download
      unless download.present?
        raise Geoblacklight::Exceptions::ExternalDownloadFailed
      end
      File.open("#{file_path}.tmp", 'wb')  do |file|
        if download.headers['content-type'] == @options[:content_type]
          file.write download.body
        else
          fail Geoblacklight::Exceptions::WrongDownloadFormat
        end
      end
      File.rename("#{file_path}.tmp", file_path)
      file_name
    rescue Geoblacklight::Exceptions::ExternalDownloadFailed
      Geoblacklight.logger.error 'Download from external server failed'
      nil
    rescue Geoblacklight::Exceptions::WrongDownloadFormat => error
      Geoblacklight.logger.error "#{error} expected #{@options[:content_type]} received #{download.headers['content-type']}"
      File.delete("#{file_path}.tmp")
      nil
    end

    def initiate_download
      url = @document.references.send(@options[:service_type]).endpoint
      url += '/reflect' if @options[:reflect]
      conn = Faraday.new(url: url)
      conn.get do |request|
        request.params = @options[:request_params]
        request.options = {
          timeout: timeout,
          open_timeout: timeout
        }
      end
    rescue Faraday::Error::ConnectionFailed => error
      Geoblacklight.logger.error error.inspect
      nil
    rescue Faraday::Error::TimeoutError => error
      Geoblacklight.logger.error error.inspect
      nil
    end

    private

    ##
    # Returns timeout for the download request. `timeout` passed as an option to
    # the Geoblacklight::Download class
    # @returns [Fixnum] download timeout in seconds
    def timeout
      @options[:timeout] || Settings.TIMEOUT_DOWNLOAD || 20
    end
  end
end
