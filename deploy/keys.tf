resource "aws_key_pair" "echo_service_key" {
  key_name = "echo_service_key"
  public_key = "${file("${var.ssh_pub_key}")}"
}