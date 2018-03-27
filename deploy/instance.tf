resource "aws_instance" "echo_service_instance" {
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "echo_service_key"
    user_data = "${data.template_cloudinit_config.cloud-init-data.rendered}"
    tags {
        Name = "echo-service-instance"
    }
    security_groups = [ "echo_service_security_group" ]
}
