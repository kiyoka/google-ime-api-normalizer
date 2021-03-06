# -*- coding: utf-8 -*-
#
#                     Google Ime Api Normalizer
#
# -----------------------------------------------------------------------------
# 
#   Copyright (c) 2010 Kiyoka Nishiyama  <kiyoka@sumibi.org>
# 
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
# 
#    1. Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
# 
#    2. Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
# 
#    3. Neither the name of the authors nor the names of its contributors
#       may be used to endorse or promote products derived from this
#       software without specific prior written permission.
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
#   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
#   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
#   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# -----------------------------------------------------------------------------
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


# transliterate
get '/transliterate' do
  ime = GoogleImeApi.new
  jsonStr = ime.call( params[:langpair], params[:text] )
  ime.normalize( jsonStr )
end


# transliterate for unit test
get '/transliterate_test' do
  case params[:text]
  when '1'
    "[[\"\\u306B\\u307B\\u3093\\u3054\",[\"\\u65E5\\u672C\\u8A9E\",\"\\u30CB\\u30DB\\u30F3\\u30B4\",\"\\u30CB\\u30DB\\u30F3\\u8A9E\",\"\\u306B\\u307B\\u3093\\u3054\",\"\\uFF86\\uFF8E\\uFF9D\\uFF7A\\uFF9E\"]]]"
  when '2'
    "[[\"\\u3078\\u3093\\u304B\\u3093\",[\"\\u5909\\u63DB\",\"\\u8FD4\\u9084\",\"\\u3078\\u3093\\u304B\\u3093\",\"\\u504F\\u5B98\",\"\\u5909\\u6F22\"]]]"
  else
    "[]"
  end
end
