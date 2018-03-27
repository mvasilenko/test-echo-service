resource "aws_route53_health_check" "echo_service_healthcheck" {
  ip_address        = "${element(aws_instance.echo_service_instance.*.public_ip,0)}"
  port              = "${var.app_port}"
  type              = "TCP"
  failure_threshold = "3"
  request_interval  = "30"
  measure_latency   = "1"
  provider = "aws.use1"
  regions           = [ "us-east-1", "us-west-1", "eu-west-1" ]
  tags = {
    Name = "${var.app_image}-healthcheck"
   }
}