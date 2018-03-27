# test-echo-service

Requirements

* working AWS account - http://aws.amazon.com/
* AWS user with API access and rights to create keys and EC2 instance - can be created inside AWS IAM,
we will need access key and secret key
* `aws` cli tool installed
  * `brew install awscli` on MacOS X,
  * `apt-get install awscli` on Ubuntu/Debian,
  * `pip install awscli` on CentOS,

  please see
https://docs.aws.amazon.com/cli/latest/userguide/installing.html
for more information

* Docker daemon installed, Dockerhub username and password - https://www.docker.com/
* terraform installed -  https://www.terraform.io/
* `make` utility - optional, you can just execute commands from `Makefile`, `brew install` in MacOS X, `apt-get install make` in Debian/Ubuntu,
`yum install make` in CentOS
* `jq` utility - optional, pretty prints JSON output


Steps to reproduce / make it work

* Clone git repo or download it - `git clone https://github.com/mvasilenko/test-echo-service`
* `cd src`
  * `docker login` - enter your Dockerhub username and password
  * `docker build -t dockerhub_username/test-echo-service .` - this will build Docker image locally in current `.` directory,
  don't miss `.` at the end of the line
  * `docker push dockerhub_username/test-echo-service` - this will push (store) newly built image to Dockerhub,
  so it can be pulled from remote location (EC2 instance in our case)

* `cd deploy`
  * configure custom aws cli profile
    * `aws configure --profile test-echo-service` - enter your AWS access key and secret key
    OR
    *  edit `$HOME/.aws/config` and `$HOME/.aws/credentials`

    This step is needed because Amazon Route53 metrics available only in `us-east-1` region,
  alert email subscription initiated by executing `aws` command localy,
  as stated in `deploy/sns-r53-healthcheck.tf`,
  email subscription must be confirmed, by clicking on link in email from AWS CloudWatch

    Please see https://github.com/terraform-providers/terraform-provider-aws/issues/712 for more information.

  * edit `terraform.tfvars` file, place AWS and Docker credentials here, this is private file, DON'T share it
  * review `vars.tf` - default variables, edit your email at last lines
  * `terraform init` - download and init terraform providers
  * `terraform plan` - evaluate provisioning manifests, dry-run
  * `terraform apply -auto-approve` - make changes, provision infrastructure, it will output EC2 instances public IP
  * go to AWS Console, confirm email alert subscribe
  * check the service, you will see such output if everything is OK

```
$ echo -n '[17/06/2016 12:30] Time to leave' | nc 52.59.245.195 1234 | jq .
{
  "timestamp": 1466166600,
  "hostname": "host.local",
  "container": "host-container-1",
  "message": "Time to leave"
}
```

  * play with it - `ssh -l ubuntu ec2_instance_ip` from previous step
    * `docker ps` - to see running containers
    * `docker logs host-container-1 -f` - container logs
    * `docker stop host-container-1` - stop echo service
    * check email for alert from AWS CloudWatch
  * `terraform destroy -force` - destroy infrastructure when you done, to prevent extra AWS charges

Files description

`src/Dockerfile` - rules for docker image build
`src/echo-server-asyncio.py` - echo server

Container with service started with `cloud-init` at instance boot. Runtime parameters
to docker container (HOSTNAME, CONTAINERNAME, PORT) are passed as environment variables.

`deploy/*.tf` - terraform provisioning manifests
`deploy/files/cloud-init.cfg` - Cloud-init template

What can be improved or done in other way

* make docker image private - now it's public, so passing dockerhub username/password to `cloud-init` is pretty useless
* send email in event of a service recovery (not done)
* store terraform state at S3
* store terraform AWS credentials in `$HOME/.aws` instead of `terraform.tfvars`
* better handling for `cloud-init` steps - now all steps (install docker daemon, docker
login, docker run) are repeated every time at every instance boot
* remote docker build instead of local - we can pack `docker build` command
into `cloud-init` configs, this will get rid of Dockerhub and `push`/`pull` operations
* versioning for image - embed `git describe` or equivalent in docker image tag
* implement load balancing and AWS auto scaling, triggered by health check
