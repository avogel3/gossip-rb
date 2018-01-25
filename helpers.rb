require 'faraday'

Thread.abort_on_exception = true # don't want this to fail silently

def every(seconds:)
  Thread.new do
    loop do
      sleep seconds
      yield
    end
  end
end

def gossip(port:, message:)
  Faraday.post("http://localhost:#{port}/message", message: message)
end
