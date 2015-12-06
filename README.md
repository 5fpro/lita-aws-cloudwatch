# lita-aws-cloudwatch

[![Build Status](https://travis-ci.org/5fpro/lita-aws-cloudwatch.svg?branch=master)](https://travis-ci.org/5fpro/lita-aws-cloudwatch)

Receive AWS CloudWatch alerm from AWS SNS (Simple Notification Service), and messaging to room.

# Features

- Supporting multiple AWS accounts.
- Notify to different room for each AWS acount.
- Can reveice SNS confirmation data.
- Show `AWS AccountID` while receiving SNS confirmation data.

## Installation

1. Add lita-aws-cloudwatch to your Lita instance's Gemfile:

``` ruby
gem "lita-aws-cloudwatch"
```

2. See <a href="#configuration">Configuration</a>.

3. Restart lita.

(goto AWS web console...)

4. Create `Topic` in AWS SNS.

5. Create SNS `Subscription` from `Topic`
- choose Protocol to `HTTP`.
- set Endpoint to `http://123.123.123.123:8888/aws-cloudwatch/receive`
- You will receive confirmation link from lita notify (click the link to finish confirmation).

4. Set CloudWatch notification to topic.

5. Done :)

## Configuration

1. You must enable lita `http routing` and `redis` in `lita_config.rb`

```
  config.redis['host'] = "127.0.0.1"
  config.redis['port'] = 6379

  config.http.port = 8888
```

2. Default room name while account is not set yet.

```
  config.handlers.aws_cloudwatch.default_room = "general"
```


## Usage

- list all aws accounts. Including account id, name, room.
```
aws account list
```

- set account name.
```
# aws account set [account id] [account name]
aws account set 123123 5Fpro co. ltd.
```

- set notify room for account. If you use Slack, it need to invite lita robot to room.
```
# aws account set [account id] [room name]
aws account set 123123 #server-state.
```

## License

[MIT](http://opensource.org/licenses/MIT)
