require 'arkcon/version'
require 'arkcon/ark_server'
require 'arkcon/ark_monitor'
module Arkcon
  # Your code goes here...
  def self.connect(address, port, password, display_name = 'Admin')
    SteamSocket.timeout = 3000
    socket = RCONSocket.new address, port

    server = Arkcon::ArkServer.new socket, display_name
    server.authenticate password
    server
  end
end
