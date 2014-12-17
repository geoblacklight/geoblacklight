class HglDownload < Download
  def initialize(document, email)

    request_params = {
      "LayerName" => document[:layer_id_s].sub(/^cite:/, ''),
      "UserEmail" => email
    }
    super(document, {
      request_params: request_params,
      service_type: 'hgl'
    })
  end

  def get
    initiate_download
  end
end
