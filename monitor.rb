require 'faye/websocket'
require 'eventmachine'
require 'json'

def monitor(data)
  store_name = data['store']
  store_name = store_name.gsub("ALDO", '')

  return "ATTENTION -#{store_name} inventory is almost full, with #{data['inventory']}!" if data['inventory'] > 80
  return "WARNING -#{store_name} inventory is almost empty, with #{data['inventory']}!" if data['inventory'] < 20
  return "INFO -#{store_name} inventory is ok, with #{data['inventory']}!"
end

EM.run {
  ws = Faye::WebSocket::Client.new('ws://localhost:8080/')

  ws.on :message do |event|
    p monitor(JSON.parse(event.data))
  end
}