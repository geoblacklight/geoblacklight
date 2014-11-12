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
    File.open("#{file_path}.tmp", 'wb')  do |file|
      if download.headers['content-type'] == @options[:content_type]
        file.write download.body
      else
        fail 'Wrong type of download'
      end
    end
    File.rename("#{file_path}.tmp", file_path)
    file_name
  rescue
    File.delete("#{file_path}.tmp")
    nil
  end

  def initiate_download
    conn = Faraday.new(url: @document[@options[:service_type]])
    conn.get do |request|
      request.params = @options[:request_params]
      request.options = {
        timeout: 10,
        open_timeout: 10
      }
    end
  rescue Faraday::Error::ConnectionFailed => error
    puts error
    nil
  rescue Faraday::Error::TimeoutError => error
    puts error
    nil
  end
end
