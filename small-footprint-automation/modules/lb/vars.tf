variable "az" {
  description = "AWS az"
}

variable "cert_arn" {
  description = "AWS ARN of the certificate to use on the load balancer.  This should be the wildcard cert for your system.<foo>.com and apps.<foo>.com domains."
}

variable "lb_subnet" {
  description = "AWS ID for the subnet in the VPC to use"
}

variable "lb_security_group" {
  description = "AWS ID for the load balancer security group."
}
