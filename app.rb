require 'sinatra'
require 'json'

get '/' do
  respond_message "hello world"
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end
