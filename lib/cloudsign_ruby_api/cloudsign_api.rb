require 'httpclient'
require 'json'
require 'pry'

class CloudsignApi
  CLOUDSIGN_API_URL = 'https://api.cloudsign.jp'.freeze
  def initialize(client_id)
    @client_id = client_id
    @client = HTTPClient.new
    @access_token = nil
    @error = nil
    check_client_id
  end

  def check_client_id
    unless fetch_access_token
      p @error
      raise InvalidClientIdError
    end
  end

  def fetch_access_token
    url = build_url('/token')
    params = {client_id: @client_id}
    response = @client.get(url, query: params)
    json = JSON.parse(response.body)
    if response.code == 200      
      @access_token = json['access_token']
      true
    else
      @error = json
      false
    end    
  end

  def documents
    fetch_access_token
    url = build_url('/documents')
    params = {}
    response = @client.get(url, query: params, header: build_header)
    JSON.parse(response.body)
  end

  private

  def build_url(method)
    CLOUDSIGN_API_URL + method
  end

  def build_header
    {Authorization: "Bearer #{@access_token}"}
  end
end