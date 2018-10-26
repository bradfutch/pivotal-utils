resource "aws_instance" "opsman" {
    ami = "${var.opsman_ami}"
    instance_type = "t2.medium"
    associate_public_ip_address = true
    availability_zone = "${var.az}"
    subnet_id = "${var.jumpbox_subnet}"
    key_name = "pcf"
    vpc_security_group_ids = [
      "${var.jumpbox_security_group}",
      "${var.bosh_security_group}"
    ]
    root_block_device = {
        volume_type = "standard"
        volume_size = "50"
    }
}

output "opsman_connect" {
  value = "https://${aws_instance.opsman.public_ip}"
}
