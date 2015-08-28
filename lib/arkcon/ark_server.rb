require 'steam-condenser'
#require 'pry'
module Arkcon
  class ArkServer

    def initialize(socket, user_name = 'Admin')
      @socket = socket
      @my_username = user_name
    end

    def authenticate(password)
      @password = password
      authenticate!
    end

    def authenticate!
      @socket.send RCONAuthRequest.new(new_request_id, @password)
      @socket.reply
    end

    def broadcast(message)
      exec "broadcast #{message}"
    end

    def send_chat(message)
      exec "serverchat #{message}"
    end

    def chat_to_steam_id(steam_id, message)
      exec "serverchatto \"#{steam_id}\" #{format_chat_message(message)}"
    end

    def chat_to_player(player_name, message)
      exec "serverchattoplayer \"#{player_name}\" #{format_chat_message(message)}"
    end

    def get_chat
      resp = exec 'getchat'
      lines = resp.response.split "\n"
      chat_data = []
      lines.each do |line|
        user, text = line.split( ': ', 2)
        chat_data << {user: user, text: text} unless text.nil?

      end
      chat_data
    end

    def kick_player(steam_id)
      exec "kickplayer #{steam_id}"
    end

    def ban_player(steam_id)
      exec "banplayer #{steam_id}"
    end

    def unban_player(steam_id)
      exec "banplayer #{steam_id}"
    end

    def pause
      exec 'pause'
    end

    def players_only
      exec 'playersonly'
    end

    alias_method :pause_all_but_players, :players_only


    def slo_mo(scale)
      exec "slomo #{scale}"
    end


    def destroy_all_enemies
      exec 'destroyallenemies'
    end

    def set_time_of_day(time)
      exec "settimeofday #{time}"
    end

    def save_world
      exec 'saveworld'
    end

    def do_exit
      exec 'doexit'
    end

    def set_motd(message)
      exec "setmessageoftheday #{message}"
    end

    def show_motd(seconds)
      exec "showmessageoftheday #{seconds}"
    end


    def list_players
      resp = exec 'listplayers'

      lines = resp.response.split "\n"
      user_data = []
      lines.each do |line|
        index, user_info = line.split( '. ', 2)
        unless user_info.nil?
          username, steamid = user_info.split( ', ', 2)
          user_data << {index: index, user: username, steamid: steamid}
        end

      end
      user_data
    end

    def allow_player_to_join_no_check(player_name)
      exec "allowplayertojoinnocheck #{player_name}"
    end

    def disallow_player_to_join_no_check(player_name)
      exec "disallowplayertojoinnocheck #{player_name}"
    end

    def exec(command)
      @socket.send RCONExecRequest.new(new_request_id, command)
      @socket.reply
    end

    private

    def format_chat_message(message)
      return "#{@my_username}: #{message}" unless @my_username.empty?
      message
    end

    def new_request_id
      rand 2**16
    end


  end
end