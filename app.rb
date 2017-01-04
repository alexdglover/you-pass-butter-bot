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
  image_response "http://www.reactiongifs.us/wp-content/uploads/2016/02/riggity_wrecked_son_rick_morty.gif"
end

post '/planning-for-failure' do
  image_response "http://2.media.dorkly.cvcdn.com/78/27/5e7374300a84037f2bdbc061f2e69211.jpg"
end

post '/where-are-my-testicles-summer' do
  image_response "http://i.imgur.com/xOcpvUM.png"
end

post '/you-pass-butter' do
  image_response "https://media.giphy.com/media/Fsn4WJcqwlbtS/giphy.gif"
end

post '/the-answer-is-dont-think-about-it' do
  image_response "http://i.imgur.com/L88mBul.jpg"
end

post '/its-getting-weird' do
  image_response "https://i.imgur.com/bBLnvGu.jpg"
end

post '/i-just-wanna-die' do
  image_response "http://i.imgur.com/CkmvRq8.jpg"
end

post '/wubalubadubdub' do
  image_response "http://i.imgur.com/fub72FV.png"
end

post '/im-mr-meseeks-look-at-me' do
  image_response "https://ih1.redbubble.net/image.23643868.0357/sticker,375x360.png"
end

post '/peace-among-worlds' do
  image_response "https://ih0.redbubble.net/image.92099583.8371/pp,550x550.u1.jpg"
end

post '/theyre-bureaucrats-morty' do
  image_response "https://s-media-cache-ak0.pinimg.com/600x315/eb/f5/f1/ebf5f1171db822953076ef15355b17f5.jpg"
end

post '/my-man' do
  image_response "https://media.giphy.com/media/qPVzemjFi150Q/giphy.gif"
end

post '/snap-yes' do
  image_response "http://i.imgur.com/gd9zPgB.gif"
end

post '/ants-in-my-eyes' do
  image_response "http://cdn.smosh.com/sites/default/files/2016/02/rick-morty-ants.jpg"
end

post '/ooh-yeah-can-do' do
  image_response "https://media.giphy.com/media/DgLsbUL7SG3kI/giphy.gif"
end

post '/lick-lick-lick-my-balls' do
  image_response "https://s-media-cache-ak0.pinimg.com/736x/35/6a/09/356a09cdbd08a2da289e7e1fdd2ae995.jpg"
end

post '/time-to-get-schwifty' do
  image_response "https://media.giphy.com/media/bcWtZEuGZhDZm/giphy.gif"
end

post '/dont-hate-the-player' do
  image_response "https://media.giphy.com/media/x9DVHBmO750Ji/giphy.gif"
end

post '/im-tiny-rick' do
  image_response "https://media.giphy.com/media/2s0ouek7HJmWQ/giphy.gif"
end

post '/i-asked-you-to-do-one-thing' do
  image_response "https://media.giphy.com/media/vV5g3lCOzqAhO/giphy.gif"
end

post '/hardest-working-liver' do
  image_response "https://media.giphy.com/media/xTiTnkjij69A2S06WY/giphy.gif"
end

post '/dont-even-trip-dawg' do
  image_response "https://media.giphy.com/media/ayQ99hp01HFN6/giphy.gif"
end

post '/being-nice' do
  image_response "https://media.giphy.com/media/FJovzGlbuoEXm/giphy.gif"
end

post '/not-today' do
  image_response "http://i.imgur.com/kxHrcC5.gif"
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
