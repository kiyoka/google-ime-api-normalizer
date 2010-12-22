#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'uri'
require 'net/http'

Net::HTTP.version_1_2
body = ""
Net::HTTP.start('www.google.com', 80) {|http|
  path = sprintf( '/transliterate?langpair=%s&text=%s', 'ja-Hira|ja', URI.encode( "へんかん" ))
  response = http.get(path)
  body = response.body
}
puts body

