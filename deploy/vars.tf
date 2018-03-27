variable "region" {
  default = "eu-central-1"
}

variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "ssh_pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  # Ubuntu 16.04LTS
  default = "ami-5055cd3f"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "cloud_init_cfg" {
  default = "cloud-init.cfg"
}

variable "dockerhub_username" {}

variable "dockerhub_password" {}

variable "hostname" {
  default = "idemia.local"
}

variable "app_container_name" {
  default = "idemia-container-1"
}

variable "app_port" {
  default = "1234"
}

variable "app_image" {
  default = "test-echo-service"
}

variable "sns-subscribe-list" {
  default = "your@email.com"
}