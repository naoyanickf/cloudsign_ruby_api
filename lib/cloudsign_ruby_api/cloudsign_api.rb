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

  def make_contract(template_id, name, email, data = [])
    document = create_documents(template_id)
    update_receiver_participant(document, name, email)

    sender_widgets = document['files'][0]['widgets'].select { |widget| widget['widget_type'] == 1 }
    sender_widgets.each_with_index do |widget, i|
      update_document_detail(document, widget, data[i])
    end
    
    send_document(document)
  end

  def documents
    fetch_access_token
    url = build_url('/documents')
    params = {}
    response = @client.get(url, query: params, header: build_header)
    JSON.parse(response.body)
  end

  def create_documents(template_id)
    fetch_access_token
    url = build_url('/documents')
    params = {template_id: template_id}
    response = @client.post(url, query: params, header: build_header)
    JSON.parse(response.body)
  end

  def update_receiver_participant(document, name, email)
    document_id = document['id']
    receiver_id = document['participants'][1]['id']    
    fetch_access_token
    url = build_url("/documents/#{document_id}/participants/#{receiver_id}")
    params = {email: email, name: name}
    response = @client.put(url, query: params, header: build_header)
    JSON.parse(response.body)
  end

  def update_document_detail(document, widget, text)
    document_id = document['id']
    file_id = widget['file_id']
    widget_id = widget['id']
    page = widget['page']
    participant_id = widget['participant_id']
    fetch_access_token
    url = build_url("/documents/#{document_id}/files/#{file_id}/widgets/#{widget_id}")
    params = {participant_id: participant_id, page: page, text: text}
    response = @client.put(url, query: params, header: build_header)
    JSON.parse(response.body)
  end

  def send_document(document)
    document_id = document['id']
    fetch_access_token
    url = build_url("/documents/#{document_id}")
    params = {}
    response = @client.post(url, query: params, header: build_header)
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