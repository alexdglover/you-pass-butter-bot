require 'sinatra'
require 'json'
require 'httparty'

set :protection, :except => [:json_csrf]



################################################
# Generic routes
################################################

get '/' do
  string_as_json_response "hello world"
end

get '/oauth' do
  response = HTTParty.post("https://slack.com/api/oauth.access?client_id=122992570306.122925378483&client_secret=8be8c881f06d9a585b7c9e43be0185e8&code=#{params['code']}")
  responseBody = JSON.parse(response.body)
  if responseBody['ok'] == true
    "<h1>You've just installed the ButterPassingRobot! Let's get riggety wrecked!!!</h1>"
  else
    response.body
  end
end

################################################
# Image fetching routes
################################################

post '/nobody-exists-on-purpose' do
  image_response "http://cdn.smosh.com/sites/default/files/2015/12/rickmorty15.jpg"
end


post '/wriggety-wriggety-wrecked-son' do
  image_response "http://images.8tracks.com/cover/i/002/072/259/Wrecked-1913.jpg"
end

post '/planning-for-failure' do
  image_response "http://2.media.dorkly.cvcdn.com/78/27/5e7374300a84037f2bdbc061f2e69211.jpg"
end

post '/where-are-my-testicles-summer' do
  image_response "http://i.imgur.com/xOcpvUM.png"
end

post '/you-pass-butter' do
  image_response "http://i.imgur.com/qgdGda1.png"
end

# Utility functions

def image_response url
  message = {
    :response_type => "in_channel",
    :attachments => [
      { :image_url => url }
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
