variable "yourip" {
  description = "look up your ip address through: whatsmyip.com put in cidr notation"
}

variable "region" {
  description = "AWS region"
}

variable "az" {
  description = "AWS az"
}

variable "cert_arn" {
  description = "AWS ARN of the certificate to use on the load balancer.  This should be the wildcard cert for your system.<foo>.com and apps.<foo>.com domains."
}

variable "opsman_ami" {
  description = "The AMI for the opsmanager in your region"
}

variable "access_key_id" {
  description = "AWS access_key_id"
}

variable "secret_access_key" {
  description = "AWS secret_access_key"
}

variable "default_key_name" {
  description = "default_key_name for connecting to ec2 instance"
}

variable "private_key" {
  description = "the pem file contents to connect to ec2 instances"
}
