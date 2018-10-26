

data "template_file" "bosh_deploy" {
  template = "${file("${path.module}/bin/bosh_deploy.tpl")}"

  vars {
    subnet_id = "${var.jumpbox_subnet}"
    region = "${var.region}"
    bosh_subnet = "${var.bosh_subnet}"
    bosh_security_group = "${var.bosh_security_group}"
    access_key_id = "${var.access_key_id}"
    secret_access_key = "${var.secret_access_key}"
    default_key_name = "${var.default_key_name}"
  }
}

data "template_file" "ssh_key" {
  template = "${file("${path.module}/bin/ssh_key.tpl")}"

  vars {
    private_key = "${var.private_key}"
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jumpbox" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.small"
    associate_public_ip_address = true
    availability_zone = "us-west-2a"
    subnet_id = "${var.jumpbox_subnet}"
    key_name = "pcf"
    vpc_security_group_ids = [
      "${var.jumpbox_security_group}",
      "${var.bosh_security_group}"
    ]

    provisioner "remote-exec" {
      inline = [
        "mkdir initScripts"
      ]
      connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${var.private_key}"
       }
    }

    provisioner "file" {
      source = "${path.module}/bin/init.sh"
      destination = "initScripts/init.sh"
      connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${var.private_key}"
       }
    }

    provisioner "remote-exec" {
      inline = [
        "sudo chmod +x initScripts/init.sh",
        "sudo sh initScripts/init.sh"
      ]
      connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${var.private_key}"
       }
    }

    provisioner "file" {
      content = "${data.template_file.bosh_deploy.rendered}"
      destination = "initScripts/bosh_deploy.sh"
      connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${var.private_key}"
      }
    }

    provisioner "file" {
      content = "${data.template_file.ssh_key.rendered}"
      destination = "/home/ubuntu/.ssh/${var.default_key_name}.pem"
      connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${var.private_key}"
      }
    }

    # provisioner "remote-exec" {
    #   inline = [
    #     "sudo sh initScripts/bosh_deploy.sh"
    #   ]
    #   connection {
    #     type     = "ssh"
    #     user     = "ubuntu"
    #     private_key = "${var.private_key}"
    #    }
    # }
}

output "jumpbox_connect" {
  value = "ssh -i ~/.ssh/${var.default_key_name}.pem ubuntu@${aws_instance.jumpbox.public_ip}"
}
