# lita-aws-cloudwatch

[![Build Status](https://travis-ci.org/5fpro/lita-aws-cloudwatch.svg?branch=master)](https://travis-ci.org/5fpro/lita-aws-cloudwatch)

Receive AWS CloudWatch alerm from AWS SNS (Simple Notification Service), and messaging to room.

# Features

- Supporting multiple AWS accounts.
- Notify to different room for each AWS acount.
- Can reveice SNS confirmation data.
- Show `AWS AccountID` while receiving SNS confirmation data.

## Installation

- Add lita-aws-cloudwatch to your Lita instance's Gemfile:
``` ruby
gem "lita-aws-cloudwatch"
```

- See <a href="#configuration">Configuration</a>.

- Restart lita.

(goto AWS web console...)

- Create `Topic` in AWS SNS.

- Create SNS `Subscription` from `Topic`
  - choose Protocol to `HTTP`.
  - set Endpoint to `http://123.123.123.123:8888/aws-cloudwatch/receive`
  - You will receive confirmation link from lita notify (click the link to finish confirmation).

- Set CloudWatch notification to topic.

- Done :)

## Configuration

- You must enable lita `http routing` and `redis` in `lita_config.rb`
```
  config.redis['host'] = "127.0.0.1"
  config.redis['port'] = 6379

  config.http.port = 8888
```

- Default room name while account is not set yet.
```
  config.handlers.aws_cloudwatch.default_room = "general"
```


## Usage

- list all aws accounts. Including account id, name, room.
```
aws account list
```

- `aws account set [account id] [account name]` : set account name.
```
aws account set 123123 5Fpro co. ltd.
```

- `aws account set [account id] [room name]` : set notify room for account. If you use Slack, it need to invite lita robot to room.
```
aws account set 123123 #server-state.
```

## License

[MIT](http://opensource.org/licenses/MIT)
