require 'sinatra'
require 'faraday'
require_relative 'helpers'

PORT, PEER_PORT = ARGV.first(2)
set :port, PORT

$peers = []
$peers << PEER_PORT


# @params message
post '/message' do
  message = params[:message]
  puts "#{PORT} received your message #{message}..."
  gossip_to_peers(message)
  'OK'
end

def gossip_to_peers(message)
  $peers.each do |peer_port|
    gossip(port: peer_port, message: message)
  end
end
