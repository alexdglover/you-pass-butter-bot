require 'sinatra'
require 'json'
require 'httparty'
require 'uri'

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

COMMAND_IMAGE_MAPPING = {
  "nobody-exists-on-purpose" => "http://cdn.smosh.com/sites/default/files/2015/12/rickmorty15.jpg",
  "wriggety-wriggety-wrecked-son" => "http://www.reactiongifs.us/wp-content/uploads/2016/02/riggity_wrecked_son_rick_morty.gif",
  "planning-for-failure" => "http://2.media.dorkly.cvcdn.com/78/27/5e7374300a84037f2bdbc061f2e69211.jpg",
  "where-are-my-testicles-summer" => "http://i.imgur.com/xOcpvUM.png",
  "you-pass-butter" => "https://media.giphy.com/media/Fsn4WJcqwlbtS/giphy.gif",
  "the-answer-is-dont-think-about-it" => "http://i.imgur.com/L88mBul.jpg",
  "its-getting-weird" => "https://i.imgur.com/bBLnvGu.jpg",
  "i-just-wanna-die" => "http://i.imgur.com/CkmvRq8.jpg",
  "wubalubadubdub" => "http://i.imgur.com/fub72FV.png",
  "im-mr-meseeks-look-at-me" => "https://ih1.redbubble.net/image.23643868.0357/sticker,375x360.png",
  "peace-among-worlds" => "https://ih0.redbubble.net/image.92099583.8371/pp,550x550.u1.jpg",
  "theyre-bureaucrats-morty" => "https://s-media-cache-ak0.pinimg.com/600x315/eb/f5/f1/ebf5f1171db822953076ef15355b17f5.jpg",
  "my-man" => "https://media.giphy.com/media/qPVzemjFi150Q/giphy.gif",
  "snap-yes" => "http://i.imgur.com/gd9zPgB.gif",
  "ants-in-my-eyes" => "http://cdn.smosh.com/sites/default/files/2016/02/rick-morty-ants.jpg",
  "ooh-yeah-can-do" => "https://media.giphy.com/media/DgLsbUL7SG3kI/giphy.gif",
  "lick-lick-lick-my-balls" => "https://s-media-cache-ak0.pinimg.com/736x/35/6a/09/356a09cdbd08a2da289e7e1fdd2ae995.jpg",
  "time-to-get-schwifty" => "https://media.giphy.com/media/bcWtZEuGZhDZm/giphy.gif",
  "dont-hate-the-player" => "https://media.giphy.com/media/x9DVHBmO750Ji/giphy.gif",
  "im-tiny-rick" => "https://media.giphy.com/media/2s0ouek7HJmWQ/giphy.gif",
  "i-asked-you-to-do-one-thing" => "https://media.giphy.com/media/vV5g3lCOzqAhO/giphy.gif",
  "hardest-working-liver" => "https://media.giphy.com/media/xTiTnkjij69A2S06WY/giphy.gif",
  "dont-even-trip-dawg" => "https://media.giphy.com/media/ayQ99hp01HFN6/giphy.gif",
  "being-nice" => "https://media.giphy.com/media/FJovzGlbuoEXm/giphy.gif",
  "not-today" => "http://i.imgur.com/kxHrcC5.gif"
}

COMMAND_MEME_MAPPING = {
  "tiny-rick" => {
    "generatorID": 5200542,
    "imageID": 13939355,
    "displayName": "Tiny Rick"
  }
}

post '/images' do
  if COMMAND_IMAGE_MAPPING.key?(params['text'])
    image_response COMMAND_IMAGE_MAPPING[params['text']]
  else
    string_as_json_response "Cannot find that image. Try /rm-list-images to see a full list of images"
  end
end

post '/images/all' do
  images = COMMAND_IMAGE_MAPPING.keys.sort.join(",\n  ")
  string_as_json_response "Full list of images:\n  #{images}"
end

post '/memes' do
  text_params = params['text'].split(' ')
  response_url = params['response_url']

  if COMMAND_MEME_MAPPING.key?(text_params[0])
    generator_id = COMMAND_MEME_MAPPING[text_params[0]][:generatorID]
    text0 = URI.encode(text_params[1])
    text1 = URI.encode(text_params[2])
    # generate memes
    response = HTTParty.get("http://version1.api.memegenerator.net/" +
      "Instance_Create?username=test&password=test&languageCode=en&" +
      "generatorID=#{generator_id}&text0=#{text0}&text1=#{text1}")
    puts response
    if response['success']
      puts "meme generated successfully"
      puts "response URL is #{response_url} and iamge URL is #{response['result']['instanceImageUrl']}"
      post_image_to_response_url response_url, response['result']['instanceImageUrl']
      status 200
    else
      puts response['result']
      # string_as_json_response "Error generating meme"
    end
  else
    string_as_json_response "Cannot find that image. Try /rm-list-memes to see a full list of memes"
  end

end

# Utility functions

def post_image_to_response_url response_url, image_url
  message = {
    :attachments => [
      {
        :image_url => image_url,
        :fallback => "Required plain-text summary of the attachment.",
        :text => "Optional text that appears within the attachment"
      }
    ]
  }

  message = message.to_json
  puts "about to send message back to slack"
  puts "message is as follows:"
  puts message
  response = HTTParty.post(response_url, {
    :body => message,
    :headers => { 'Content-Type' => 'application/json' }
  })

end

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
