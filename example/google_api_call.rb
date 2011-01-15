#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'uri'
require 'net/http'
require 'pp'
require 'json'

def fetchJson( kana )
  body = ""
  Net::HTTP.version_1_2
  Net::HTTP.start('google-ime-api-normalizer.heroku.com', 80) {|http|
    path = sprintf( '/transliterate?langpair=%s&text=%s', 'ja-Hira|ja', URI.encode( kana ))
    response = http.get(path)
    body = response.body
  }
end

arr = [
       "せれんでぃぴてぃ",
       "しょかいきどう",
       "たけうちかんすう",
       "あいまいもじれつ",
       "あいまいけんさく",
       "かんじゃにえいと",
       "おれおれさぎ",
       "りあじゅう",
       "よんもじじゅくご",
       "こうかいかんすう",
       "AとBとCとD" ]
arr.each { |x|
  pp JSON.parse( fetchJson( x ))
}
