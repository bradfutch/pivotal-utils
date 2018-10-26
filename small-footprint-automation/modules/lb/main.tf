resource "aws_elb" "pcf-web" {
  name            = "pcf-web"
  subnets         = ["${var.lb_subnet}"]
  security_groups = ["${var.lb_security_group}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.cert_arn}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/health"
    interval            = 30
  }

  instances                   = []
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "pcf-web"
  }
}

output "lb_id" {
  value = "${aws_elb.pcf-web.id}"
}
