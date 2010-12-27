#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
#
# normalizer_spec.rb -  "RSpec file for Google Ime Api Normalizer"
#  
#   Copyright (c) 2009-2010  Kiyoka Nishiyama  <kiyoka@sumibi.org>
#   
#   Redistribution and use in source and binary forms, with or without
#   modification, are permitted provided that the following conditions
#   are met:
#   
#   1. Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#  
#   2. Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#  
#   3. Neither the name of the authors nor the names of its contributors
#      may be used to endorse or promote products derived from this
#      software without specific prior written permission.
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
require 'uri'
require 'net/http'
require 'json'

class WebApi
  def initialize( host )
    @host = host
    @port = 80
  end
  
  def call( kana )
    body = ""
    Net::HTTP.version_1_2
    Net::HTTP.start(@host, @port) {|http|
      path = sprintf( '/transliterate?langpair=%s&text=%s', 'ja-Hira|ja', URI.encode( kana ))
      response = http.get(path)
      body = response.body
    }
    body.gsub( /\n/, "" )
  end
end


describe "when accessing google" do
  before do
    @webApi = WebApi.new( 'www.google.com' )
  end

  it "should" do
    @webApi.call( 'にほんご' ).should == "[[\"\\u306B\\u307B\\u3093\\u3054\",[\"\\u65E5\\u672C\\u8A9E\",\"\\u30CB\\u30DB\\u30F3\\u30B4\",\"\\u30CB\\u30DB\\u30F3\\u8A9E\",\"\\u4E8C\\u672C\\u5F8C\",\"\\u306B\\u307B\\u3093\\u3054\",],],]"
    @webApi.call( 'へんかん' ).should == "[[\"\\u3078\\u3093\\u304B\\u3093\",[\"\\u5909\\u63DB\",\"\\u8FD4\\u9084\",\"\\u504F\\u5B98\",\"\\u3078\\u3093\\u304B\\u3093\",\"\\u8FD4\\u7C21\",],],]"
  end
end


describe "when accessing google normalizer on Heroku" do
  before do
    @webApi = WebApi.new( 'google-ime-api-normalizer.heroku.com' )
  end

  it "should" do
    @webApi.call( 'にほんご' ).should == "[[\"\\u306B\\u307B\\u3093\\u3054\",[\"\\u65E5\\u672C\\u8A9E\",\"\\u30CB\\u30DB\\u30F3\\u30B4\",\"\\u30CB\\u30DB\\u30F3\\u8A9E\",\"\\u4E8C\\u672C\\u5F8C\",\"\\u306B\\u307B\\u3093\\u3054\"]]]"
    JSON.parse( @webApi.call( 'にほんご' )).should == [["にほんご", ["日本語", "ニホンゴ", "ニホン語", "二本後", "にほんご"]]]

    @webApi.call( 'へんかん' ).should == "[[\"\\u3078\\u3093\\u304B\\u3093\",[\"\\u5909\\u63DB\",\"\\u8FD4\\u9084\",\"\\u504F\\u5B98\",\"\\u3078\\u3093\\u304B\\u3093\",\"\\u8FD4\\u7C21\"]]]"
    JSON.parse( @webApi.call( 'へんかん' )).should == [["へんかん", ["変換", "返還", "偏官", "へんかん", "返簡"]]]

    @webApi.call( 'かんじゃにえいと' ).should == "[[\"\\u304B\\u3093\\u3058\\u3083\\u306B\\u3048\\u3044\\u3068\",[\"\\u95A2\\u30B8\\u30E3\\u30CB\\u30A8\\u30A4\\u30C8\",\"\\u60A3\\u8005\\u306B\\u6804\\u3068\",\"\\u60A3\\u8005\\u306B\\u82F1\\u3068\",\"\\u60A3\\u8005\\u306B\\u30A8\\u30A4\\u30C8\",\"\\u304B\\u3093\\u3058\\u3083\\u306B\\u3048\\u3044\\u3068\"]]]"
    JSON.parse( @webApi.call( 'かんじゃにえいと' )).should == [["かんじゃにえいと", ["関ジャニエイト", "患者に栄と", "患者に英と", "患者にエイト", "かんじゃにえいと"]]]

    @webApi.call( 'さいみつもり' ).should == "[[\"\\u3055\\u3044\\u307F\\u3064\\u3082\\u308A\",[\"\\u518D\\u898B\\u7A4D\\u308A\",\"\\u518D\\u898B\\u7A4D\\u3082\\u308A\",\"\\u6700\\u898B\\u7A4D\\u308A\",\"\\u518D\\u898B\\u7A4D\",\"\\u3055\\u3044\\u307F\\u3064\\u3082\\u308A\"]]]"
    JSON.parse( @webApi.call( 'さいみつもり' )).should == [["さいみつもり", ["再見積り", "再見積もり", "最見積り", "再見積", "さいみつもり"]]]
  end
end
