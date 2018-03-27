provider "aws" {
    region = "us-east-1"
    alias  = "use1"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

provider "aws" {
    region = "${var.region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}
# at production it's recommended to store state at S3 or Vault
# but this will add one more manual step - creating S3 bucket or Vault setup
#
#data "terraform_remote_state" "trss" {
#  backend = "s3"
#
#  config {
#    bucket     = "${var.s3bucket}"
#    key        = "terraform.tfstate"
#    region     = "${var.region}"
#    encrypt    = true
#  }
#}
#
#terraform {
#  backend "s3" {
#    bucket   = "terraform-ec2-state-test-echo-service-mvasilenko"
#    key      = "terraform.tfstate"
#    region   = "eu-central-1"
#    encrypt  =  true
#  }
#}
