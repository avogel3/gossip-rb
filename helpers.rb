require 'faraday'

# Gossip Stuff

def gossip(from_port:, port:, message:)
  Faraday.post("http://localhost:#{port}/message", from_port: from_port, message: message).body
rescue Faraday::ConnectionFailed
end

def gossip_with_peers(peer_port)
  Faraday.get("http://localhost:#{peer_port}/messages_history").body
rescue Faraday::ConnectionFailed
end

# Convenience

Thread.abort_on_exception = true # don't want this to fail silently

def every(seconds:)
  Thread.new do
    loop do
      sleep seconds
      yield
    end
  end
end

def timestamp
  Time.now.to_i.to_s
end
