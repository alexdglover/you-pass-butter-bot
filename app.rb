require 'sinatra'
require 'json'



set :protection, :except => [:json_csrf]

class SlackOAuthHttpClient
  include HTTParty
  base_uri 'https://slack.com/api/oauth.access'
end



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

get '/oauth' do
  # hash_as_json_response params
  # post to https://slack.com/api/oauth.access
  # client_id	  Client ID of your registered Slack application.
  # client_secret	  Client Secret of your registered Slack application.
  # code	  The code returned by Slack in the query string parameter.
  # options = {
  #   body: {
  #     pear: { # your resource
  #       foo: '123', # your columns/data
  #       bar: 'second',
  #       baz: 'last thing'
  #     }
  #   }
  # }
  #
  # pp Partay.post('/pears.xml', options)
  response = HTTParty.post('https://slack.com/api/oauth.access?client_id=122992570306.122925378483&client_secret=8be8c881f06d9a585b7c9e43be0185e8')
  puts response.body
end

def hash_as_json_response message
  content_type :json
  message.to_json
end

def string_as_json_response message
  content_type :json
  { :text => message }.to_json
end
