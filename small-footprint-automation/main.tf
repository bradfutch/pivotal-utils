provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source = "modules/vpc"
  az = "${var.az}"
}

module "secgrp" {
  source = "modules/secgrp"
  vpc = "${module.vpc.vpc_id}"
  yourip = "${var.yourip}"
}

module "lb" {
  source = "modules/lb"
  az = "${var.az}"
  cert_arn = "${var.cert_arn}"
  lb_security_group = "${module.secgrp.bosh_security_group}"
  lb_subnet = "${module.vpc.public_subnet}"
}

module "jumpbox" {
  source = "modules/jumpbox"
  jumpbox_subnet = "${module.vpc.public_subnet}"
  bosh_subnet = "${module.vpc.public_subnet}"
  jumpbox_security_group = "${module.secgrp.jumpbox_security_group}"
  access_key_id = "${var.access_key_id}"
  secret_access_key = "${var.secret_access_key}"
  region = "${var.region}"
  default_key_name = "${var.default_key_name}"
  bosh_security_group = "${module.secgrp.bosh_security_group}"
  private_key = "${var.private_key}"
}

module "opsman" {
  source = "modules/opsman"
  jumpbox_subnet = "${module.vpc.public_subnet}"
  opsman_ami = "${var.opsman_ami}"
  bosh_subnet = "${module.vpc.public_subnet}"
  jumpbox_security_group = "${module.secgrp.jumpbox_security_group}"
  access_key_id = "${var.access_key_id}"
  secret_access_key = "${var.secret_access_key}"
  az = "${var.az}"
  default_key_name = "${var.default_key_name}"
  bosh_security_group = "${module.secgrp.bosh_security_group}"
  private_key = "${var.private_key}"
}

output "opsman_connect" {
  value = "${module.opsman.opsman_connect}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "management_subnet" {
    value = "${module.vpc.management_subnet}"
}
output "management_subnet_cidr" {
    value = "${module.vpc.management_subnet_cidr}"
}
output "pas_subnet" {
    value = "${module.vpc.pas_subnet}"
}
output "pas_subnet_cidr" {
    value = "${module.vpc.pas_subnet_cidr}"
}
output "public_subnet" {
    value = "${module.vpc.public_subnet}"
}
output "public_subnet_cidr" {
    value = "${module.vpc.public_subnet_cidr}"
}

output "bosh_security_group" {
    value = "${module.secgrp.bosh_security_group}"
}
