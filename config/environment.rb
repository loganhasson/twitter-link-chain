require 'bundler/setup'
require 'yaml/store'
Bundler.require

require_relative 'twitter_api_credentials'
require_relative '../lib/tweet'
require_relative '../lib/twitter_link_chain'