require 'sinatra'
require 'active_support/time'

PORT, PEER = ARGV.first(2)

@peers = []

@peers << peer unless peer.nil?

get '/' do
  'Hello World!'
end
