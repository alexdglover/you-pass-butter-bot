require 'sinatra'
require 'json'

set :protection, :except => [:json_csrf]

get '/' do
  string_as_json_response "hello world"
end

post '/nobody-exists-on-purpose' do
  message = {
    :response_type => "in_channel",
    # :text => params['text'],
    :attachments => [
      { :image_url => "http://cdn.smosh.com/sites/default/files/2015/12/rickmorty15.jpg" }
    ]
  }
  hash_as_json_response message
end

def hash_as_json_response message
  content_type :json
  message.to_json
end

def string_as_json_response message
  content_type :json
  { :text => message }.to_json
end
