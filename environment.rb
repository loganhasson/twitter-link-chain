require 'bundler/setup'
require 'yaml/store'
Bundler.require

require_relative 'config/twitter_api_credentials'
require_relative 'tweet'
require_relative 'twitter_link_chain'