# template provisioning - include - cloud-init file
data "template_file" "cloud-init-cfg" {
  template = "${file("files/${var.cloud_init_cfg}")}"
  # set vars for cloud-init
  vars {
    hostname = "${var.hostname}"
    # remote ssh user, ubuntu for ubuntu distribution
    ssh_user = "${var.ssh_user}"
    # docker hub credentials
    dockerhub_username = "${var.dockerhub_username}"
    dockerhub_password = "${var.dockerhub_password}"
    # app container name
    app_container_name = "${var.app_container_name}"
    app_port = "${var.app_port}"
    app_image = "${var.app_image}"
  }
}


# cloudinit provisioning - get rendered data from data sources and put it into cloud-init file
data "template_cloudinit_config" "cloud-init-data" {
  gzip = false
  base64_encode = false
# include cloud-init.cfg rendered from template
  part {
    filename     = "${var.cloud_init_cfg}"
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-init-cfg.rendered}"
  }
}
