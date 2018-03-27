resource "aws_cloudwatch_metric_alarm" "echo_service_alarm" {
  alarm_name          = "${var.app_image}_healthcheck_failed"
  namespace           = "AWS/Route53"
  metric_name         = "HealthCheckStatus"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  unit                = "None"
  provider            = "aws.use1"
  dimensions = {
    HealthCheckId = "${aws_route53_health_check.echo_service_healthcheck.id}"
  }
  alarm_description   = "This metric monitors whether the service endpoint is down or not."
  alarm_actions       = [ "${aws_sns_topic.echo_service_sns_topic.arn}" ]
  insufficient_data_actions = [ ]
  treat_missing_data  = "breaching"
  depends_on          = ["aws_route53_health_check.echo_service_healthcheck"]
}