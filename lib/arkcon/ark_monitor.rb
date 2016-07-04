require 'hooks'

module Arkcon
	class ArkMonitor
		include Hooks
		include Hooks::InstanceHooks

		define_hook :chat_received, scope: lambda { |*| nil }
		define_hook :users_changed, scope: lambda { |*| nil }

		attr_reader :server

		def initialize(server)
			@server = server
			@user_list = []
			@timer = nil
			@fetching = false
			@retry_count = 0
		end

		def start(interval = 1)
			@timer = EventMachine::PeriodicTimer.new(interval) do
				fetch_data
			end

		end

		def stop
			@timer.cancel unless @timer.nil?
		end

		def fetch_data
			return if @fetching

			fetch_users
			fetch_chat
			@retry_count = 0
			@fetching = false
		end

		def fetch_chat
			chat_lines = @server.get_chat
			run_hook( :chat_received, chat_lines ) if chat_lines.count > 0
			chat_lines
		end

		def fetch_users
			user_data = @server.list_players
			new_users = user_data.select  {|user| list_contains_user(@user_list, user[:user]) == false}
			old_users = @user_list.select {|user| list_contains_user(user_data, user[:user]) == false}
			if new_users.count > 0 || old_users.count > 0
				run_hook :users_changed, user_data, new_users, old_users
			end
			@user_list = user_data
		end

		def list_contains_user(list, username)
			list.any? { |user| user[:user] == username}
		end

	end
end
