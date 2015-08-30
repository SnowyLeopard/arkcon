#!/usr/bin/env ruby

require 'bundler/setup'
require 'eventmachine'
require 'arkcon'

socket = RCONSocket.new ARGV[0], ARGV[1]
server = Arkcon::ArkServer.new socket
server.authenticate ARGV[2]

monitor = Arkcon::ArkMonitor.new(server)


monitor.chat_received do |lines|
  lines.each do |line|
    puts "#{Time.now}: #{line[:player]} (#{line[:character]}): #{line[:text]}"
  end
end

monitor.users_changed do |current_users, added_users, removed_users|
  added_users.each do |added|
    puts "#{Time.now}:  #{added[:user]} connected."
  end

  removed_users.each do |removed|
    puts "#{Time.now}:  #{removed[:user]} left."
  end
end


EventMachine.run do
  monitor.start
end
