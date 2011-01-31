#-*- mode: ruby; -*-
#-*- coding: utf-8 -*-
require 'rake'

task :check do
  sh "ruby -I ./lib /usr/local/bin/rspec -b ./test/normalizer_spec.rb"
end

task :rackup do
  sh "rackup -I . config.ru"
end
