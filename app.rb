require 'sinatra'
require 'json'

set :protection, :except => [:json_csrf]

get '/' do
  respond_message "hello world"
end

post '/morty_quote' do
  puts params
  #@keyword = params[:text]

  respond_message "you looked for a morty quote with keyword #{params['keyword']}"
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end


