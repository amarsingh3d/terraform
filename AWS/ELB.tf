# Create a new load balancer
resource "aws_elb" "tf_lb" {
  name               = "terraform-web-elb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  security_groups = ["${aws_security_group.allow_web.id}"]

  
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.webserver1.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}

resource "aws_security_group" "allow_web" {
  name  = "elb_SG"
  description = "Web Servers LB"

  ingress {
      from_port = 80 # Allow Web Server access world wide 
      to_port = 80
      protocol = "tcp"

      cidr_blocks = ["76.74.201.36/32"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
      }
}