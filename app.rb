require 'sinatra'
require 'json'

set :protection, :except => [:json_csrf]

get '/' do
  respond_message "hello world"
end

post '/morty_quote' do
  content_type :json
  {
    :response_type => "in_channel",
    :text => params['text'],
    :attachments => [
      { :image_url => "http://cdn.smosh.com/sites/default/files/2015/12/rickmorty15.jpg" }
    ]
  }.to_json
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end
