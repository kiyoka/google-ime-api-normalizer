# -*- coding: utf-8 -*-
#
require 'rubygems'
require 'sinatra'
require 'uri'
require 'net/http'

class GoogleImeApi
  def call( langpair, text )
    langpair = "" unless langpair
    text     = "" unless text

    Net::HTTP.version_1_2
    body = ""
    if (0 < langpair.size) and (0 < text.size)
      Net::HTTP.start('www.google.com', 80) {|http|
        path = sprintf( '/transliterate?langpair=%s&text=%s', langpair, URI.encode( text ))
        puts path
        response = http.get(path)
        body = response.body
      }
      body
    else
      "[]"
    end
  end

  def normalize( jsonStr )
    jsonStr.gsub( /\n/, "" ).gsub( /,\]/, "]" )
  end
end


configure :production do
  # Configure stuff here you'll want to
  # only be run at Heroku at boot
end

# translate
get '/transliterate' do
  ime = GoogleImeApi.new
  jsonStr = ime.call( params[:langpair], params[:text] )
  ime.normalize( jsonStr )
end
