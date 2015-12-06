module Lita
  module Handlers
    class AwsCloudwatch < Handler
      config :default_room, type: String, default: "general"

      route(/^aws account set ([0-9]+) (.+)$/, :set_account, command: true, help: { "aws account set [account id] [account name]" => "Set AWS account name" })
      def set_account(response)
        account_id = response.matches[0][0]
        account_name = response.matches[0][1]
        redis.hset(redis_key, account_id, account_name)
        response.reply("AWS account: #{account_id} has been set name: #{account_name}")
      end

      route(/^aws account room ([0-9]+) ([^\s]+)$/, :set_account_room, command: true, help: { "aws account room [account id] [room_name]" => "Set room for AWS account" })
      def set_account_room(response)
        account_id = response.matches[0][0]
        room_name = response.matches[0][1].gsub("#", "")
        redis.hset(redis_key_for_room, account_id, room_name)
        response.reply("AWS account: #{account_id} has set room to: ##{room_name} , please invite robot to the room.")
      end

      route(/^aws account list/, :list_accounts, command: true, help: { "aws account list" => "List all AWS accounts" })
      def list_accounts(response)
        message = accounts.keys.map{ |key| "#{key}: #{accounts[key]} ( ##{fetch_room(key)} )" }.join("\n")
        response.reply(message)
      end

      http.post "/aws-cloudwatch/receive", :receive
      def receive(request, response)
        @request = request
        case params_data["Type"]
        when "SubscriptionConfirmation"
          alert_confirmation!
        when "Notification"
          alert_notification!
        else
          alert_unknowtype!
        end
        response.write("ok")
      end

      private

      def alert_confirmation!
        message = params_data["Message"].gsub("SubscribeURL", params_data["SubscribeURL"])
        account_id = params_data["TopicArn"].split(":")[-2]
        room = fetch_room(account_id)
        send_message_to_room(message, room)
        unless accounts[account_id]
          send_message_to_room("Your AWS Account ID is `#{account_id}`, type `aws account set #{account_id} [account name]` for sett name, and type `aws account room #{account_id} [room name]` to set reporting room", room)
        end
      end

      def alert_unknowtype!
        room = config.default_room
        message = "unknow type: #{params_data["Type"].inspect} , send to robot.\n DEBUG: #{params_data.inspect}"
        send_message_to_room(message, room)
      end

      def alert_notification!
        data = JSON.parse(params_data["Message"])
        account_id = data["AWSAccountId"]
        name = data["AlarmName"]
        state = data["NewStateValue"]
        reason = data["NewStateReason"]
        messages = []
        messages << "Account: #{accounts[account_id] || account_id}"
        messages << "State: #{state}"
        messages << "Name: #{name}"
        messages << "Reason: #{reason}"
        room = fetch_room(account_id)
        send_message_to_room(messages.join("\n"), room)
      end

      def redis_key_for_room
        "aws-cloudwatch-accounts-room"
      end

      def redis_key
        "aws-cloudwatch"
      end

      def accounts
        @accounts ||= redis.hgetall(redis_key)
        @accounts
      end

      def fetch_room(account_id)
        @rooms ||= redis.hgetall(redis_key_for_room)
        @rooms[account_id] || config.default_room
      end

      def params_data
        @data ||= JSON.parse(@request.body.string)
        @data
      end

      def send_message_to_room(message, room_name = nil)
        room_name ||= config.default_room
        target = Source.new(room: find_room_id_by_name(room_name))
        robot.send_messages(target, message)
      end

      def find_room_id_by_name(room_name)
        case robot.config.robot.adapter.to_s.to_sym
        when :slack
          if room = ::Lita::Room.find_by_name(room_name)
            return room.id
          else
            ::Lita::Room.find_by_name("general").id
          end
        else
          room_name
        end
      end

      Lita.register_handler(self)
    end
  end
end
