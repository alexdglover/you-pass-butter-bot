require 'sinatra'
require 'json'

set :protection, :except => [:json_csrf]

get '/' do
  respond_message "hello world"
end

post '/morty_quote' do
#token=WizfwPgcVQbrLreHurA7m2Fx&team_id=T3LV6GS90&team_domain=alexdglover&channel_id=D3M2BT84V&channel_name=directmessage&user_id=U3L8DQ6RE&user_name=alexdglover&command=%2Fmorty_quote&text=foo&response_url=https%3A%2F%2Fhooks.slack.com%2Fcommands%2FT3LV6GS90%2F122929261683%2F4F1qD32rkVqK5KkYPVpx0XuF  
  keyword = params[:text]

  respond_message "you looked for a morty quote with keyword #{params['keyword']}"
end

def respond_message message
  content_type :json
  { :text => message }.to_json
end


