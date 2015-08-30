require 'arkcon/version'
require 'arkcon/ark_server'
require 'arkcon/ark_monitor'
module Arkcon
  # Your code goes here...
  def self.connect(address, port, password)
    socket = RCONSocket.new address, port
    server = Arkcon::ArkServer.new socket
    server.authenticate password
    server
  end
end
