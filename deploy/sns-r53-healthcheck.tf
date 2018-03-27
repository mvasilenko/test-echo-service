// CloudWatch metric alarms notify this SNS topic.
resource "aws_sns_topic" "echo_service_sns_topic" {
  name      = "${var.app_image}-alerts"
  provider = "aws.use1"

  provisioner "local-exec" {
    command = "aws sns subscribe --profile echo-service --topic-arn ${self.arn}  --protocol email --notification-endpoint ${var.sns-subscribe-list}"
  }
}
