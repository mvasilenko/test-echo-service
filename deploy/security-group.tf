resource "aws_security_group" "echo_service_security_group" {
  name = "echo_service_security_group"
  # allow incoming traffic to app
  ingress {
    from_port = "${var.app_port}"
    to_port = "${var.app_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow ssh
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow egress traffic
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}