require "spec_helper"

describe Lita::Handlers::AwsCloudwatch, lita_handler: true do
  it "#set_account" do
    send_command "aws account set 1234 5Fpro HaHa"
    expect(replies.size).to be > 0
    send_command "aws account list"
    expect(replies.last).to match("1234: 5Fpro HaHa")
  end

  it "#set_account_room" do
    send_command "aws account set 1234 5Fpro HaHa"
    send_command "aws account room 1234 #haha"
    expect(replies.size).to be > 0
    send_command "aws account list"
    expect(replies.last).to match("1234: 5Fpro HaHa ( #haha )")
  end

  context "#receive" do
    let(:account_id){ "863886017929" }
    let(:body_confirmation){ '{"Type": "SubscriptionConfirmation", "MessageId": "cb304f8d-740d-4810-b9dd-7d47a1184eb8", "Token": "2336412f37fb687f5d51e6e241d7700bdc2fd74df0fbef7c6648870dee1c4c87ab59fe66548b509ff18165e81a2a4c6b4b5803444bf84a10365c1104202a9d010019385e91a7c871bf84959b919966358f3e2ced05bd9bc1d08a86ac8bae46a1420da82c2b308a395058cb4cad8ba00cdf5efada5812e150171241d95acd5153", "TopicArn": "arn:aws:sns:ap-northeast-1:863886017929:developers", "Message": "You have chosen to subscribe to the topic arn:aws:sns:ap-northeast-1:863886017929:developers.\nTo confirm the subscription, visit the SubscribeURL included in this message.", "SubscribeURL": "https://sns.ap-northeast-1.amazonaws.com/?Action=ConfirmSubscription&TopicArn=arn:aws:sns:ap-northeast-1:863886017929:developers&Token=2336412f37fb687f5d51e6e241d7700bdc2fd74df0fbef7c6648870dee1c4c87ab59fe66548b509ff18165e81a2a4c6b4b5803444bf84a10365c1104202a9d010019385e91a7c871bf84959b919966358f3e2ced05bd9bc1d08a86ac8bae46a1420da82c2b308a395058cb4cad8ba00cdf5efada5812e150171241d95acd5153", "Timestamp": "2015-12-06T07:13:41.370Z", "SignatureVersion": "1", "Signature": "bkvpfe9br6g41XQRJOgDg99C2evpXTGsXJ8lbLfZbmt4rfloORWO5Kw0Dh7QKIijd9y/QyvU6Yo80k8DXVWfJfj/vLysjplHOsrxSmvR1F7VMZil1cyoag3c/LNHJIq0WRSJxH8O6HkT1c5SNCSWfAiqz+4tw/brtCl8gK9vmGr0eGPOcFhT46xrz0Ucc+clFlwuhAjrRoK9vRRsIyTl4NEPgtC7HyRlB+Qm+ooXi7Bk0AUnGMdTKPYB/c1bCq+A0VKCzxLKjSzIme0i59n3lxFh4zSSygbX68gay7A2FRxYfl2j6/agH5gC0jsnQh1Xgry7Y/+z0fdUwzAZoWw5Ng==", "SigningCertURL": "https://sns.ap-northeast-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem"}' }
    let(:body_notification){ '{"Type": "Notification", "MessageId": "f1cd789a-df69-5dc4-bd54-36419e0f72c4", "TopicArn": "arn:aws:sns:ap-northeast-1:863886017929:developers", "Subject": "ALARM: \"api-1 - Network In\" in APAC - Tokyo", "Message": "{\"AlarmName\":\"api-1 - Network In\",\"AlarmDescription\":null,\"AWSAccountId\":\"863886017929\",\"NewStateValue\":\"ALARM\",\"NewStateReason\":\"Threshold Crossed: 1 datapoint (2024818.75) was greater than or equal to the threshold (2000000.0).\",\"StateChangeTime\":\"2015-12-04T07:22:14.394+0000\",\"Region\":\"APAC - Tokyo\",\"OldStateValue\":\"OK\",\"Trigger\":{\"MetricName\":\"NetworkIn\",\"Namespace\":\"AWS/EC2\",\"Statistic\":\"AVERAGE\",\"Unit\":null,\"Dimensions\":[{\"name\":\"InstanceId\",\"value\":\"i-bc8dcaa5\"}],\"Period\":300,\"EvaluationPeriods\":1,\"ComparisonOperator\":\"GreaterThanOrEqualToThreshold\",\"Threshold\":2000000.0}}", "Timestamp": "2015-12-04T07:22:14.461Z", "SignatureVersion": "1", "Signature": "cW8eyf5k/+QaVZna/nhMh8HSnN7Y0BFR1fOvyYTG9seBsW4f6tGMj/wVK9aQVqVvEI3Vt54+OM0RSiiJHGOaanej2IxH+DiVo7k7VnN9uK25ejYbcp0pXusz7z7+VfzDr26QRCGF1qmq+TTx61q4PmfTIdigPZ9H9wUzQdujLxJy7vjRjJTLnhJ6fQtGCOyTfl0FTpYbVPeRT8/vu6G6XYw53hAa+sRbGiONmirwF0OzLQaW7M0FRO/Y/W8Yyr8GTNcT9egSIRED79fmkzWz2oxmEjVCJBUtvO6BBmjckCSsFB7oSDjuOKhGv5TNP29qSE36pwox0AoOnn6SoTnAlw==", "SigningCertURL": "https://sns.ap-northeast-1.amazonaws.com/SimpleNotificationService-bb750dd426d95ee9390147a5624348ee.pem", "UnsubscribeURL": "https://sns.ap-northeast-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:ap-northeast-1:863886017929:developers:dc2735b1-b160-4ec3-901e-393fd971a28a"}' }
    context "no account name, no room" do
      it "confirmation" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_confirmation
        end
        expect( response.body ).to match("ok")
      end
      it "notification" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_notification
        end
        expect( response.body ).to match("ok")
      end
    end
    context "only account id" do
      before{ send_command "aws account set #{account_id} 5Fpro" }
      it "confirmation" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_confirmation
        end
        expect( response.body ).to match("ok")
      end
      it "notification" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_notification
        end
        expect( response.body ).to match("ok")
      end
    end

    context "only room" do
      before{ send_command "aws account room #{account_id} haha" }
      it "confirmation" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_confirmation
        end
        expect( response.body ).to match("ok")
      end
      it "notification" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_notification
        end
        expect( response.body ).to match("ok")
      end
    end

    context "both room and account_id" do
      before{ send_command "aws account room #{account_id} haha" }
      before{ send_command "aws account set #{account_id} 5Fpro" }
      it "confirmation" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_confirmation
        end
        expect( response.body ).to match("ok")
      end
      it "notification" do
        response = http.post("/aws-cloudwatch/receive") do |req|
          req.body = body_notification
        end
        expect( response.body ).to match("ok")
      end
    end
  end
end
