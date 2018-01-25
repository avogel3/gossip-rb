require 'sinatra'
require 'faraday'
require 'colorize'
require_relative 'helpers'

PORT, PEER_PORT = ARGV.first(2)
set :port, PORT

$messages = {}

every(seconds: 10) do
  gossip_to_peers($messages)
end

# @params message
# @params from_port
post '/message' do
  message = params[:message]
  from_port = params[:from_port]
  set_in_messages(from_port, message)
  puts "#{PORT} received message '#{message}' from #{from_port}...".colorize(:blue)
end

# @params messages
post '/update_messages' do
  update_messages(params[:messages])
end

def gossip_to_peers(messages)
  Faraday.post("http://localhost:#{PEER_PORT}/update_messages", from_port: PORT, messages: messages.to_json).body
rescue Faraday::ConnectionFailed
end

def update_messages(messages)
  puts 'Updating messages....'.colorize(:yellow)
  parsed_messages = JSON.parse(messages)
  parsed_messages.each do |k, v|
    next if $messages.key?(k)
    $messages[k] = v
    puts '...Messages updated!'.colorize(:green)
  end
  puts $messages.to_json.colorize(:magenta) if $messages != messages
end

def set_in_messages(from_port, message)
  $messages[timestamp] = { from_port: from_port, messsage: message }
end
