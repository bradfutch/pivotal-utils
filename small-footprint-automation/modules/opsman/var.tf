variable "jumpbox_subnet" {
  description = "subnet for jumpbox"
}

variable "opsman_ami" {
  description = "The AMI to use for the opsmanager"
}

variable "bosh_subnet" {
  description = "The subnet for the Bosh Director"
}

variable "jumpbox_security_group" {
  description = "security group for jumpbox"
}

variable "access_key_id" {
  description = "AWS access_key_id"
}

variable "secret_access_key" {
  description = "AWS secret_access_key"
}

variable "az" {
  description = "az for the deployment"
}

variable "default_key_name" {
  description = "default_key_name for logging into ec2 instance"
}

variable "bosh_security_group" {
  description = "Security group for bosh Director"
}

variable "private_key" {
  description = "the pem file contents to connect to ec2 instances"
}
