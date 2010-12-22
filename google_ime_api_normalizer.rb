# $ ruby google_ime_api_normalizer.rb
#
require 'rubygems'
require 'sinatra'

configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot
end

# Quick test
get '/' do
  "Congradulations!
   You're running a Sinatra application on Heroku!"
end

# Test at <appname>.heroku.com

# You can see all your app specific information this way.
# IMPORTANT! This is a very bad thing to do for a production
# application with sensitive information

get '/env' do
  ENV.inspect
end
