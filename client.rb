require 'sinatra'
require 'colorize'
require_relative 'helpers'

PORT, *PEER_PORTS = ARGV
set :port, PORT

$messages = {}

every(seconds: 10) do
  peer_message_history = gossip_with_peers(PEER_PORTS.sample)
  update_messages_history(peer_message_history)
end

post '/message' do
  receive_message(params[:message], params[:from_port])
end

get '/messages_history' do
  JSON.dump($messages)
end

def receive_message(message, from_port)
  return if message.nil? || message.empty?
  $messages[timestamp] = message
  puts "Received message '#{message}' from #{from_port}...".colorize(:blue)
end

def update_messages_history(messages)
  parsed_messages = JSON.parse(messages)
  parsed_messages.each do |k, v|
    next if $messages.key?(k)
    puts 'Updating message history....'.colorize(:yellow)
    $messages[k] = v
    puts '...Message history updated!'.colorize(:green)
  end
  puts JSON.dump($messages).colorize(:magenta) if $messages != messages
end
