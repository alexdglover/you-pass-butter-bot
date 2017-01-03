require 'sinatra'
require 'json'

set :protection, :except => [:json_csrf]

get '/' do
  respond_message "hello world"
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end
