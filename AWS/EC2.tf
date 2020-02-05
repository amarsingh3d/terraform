# Define your AWS access
provider "aws" {
 
  region   = "us-east-1"
  shared_credentials_file = "c:/Users/admin/.aws/config"
  profile = "default"
 
}
# Create AWS EC2 Instance
 
resource "aws_instance" "webserver1" {
 
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"
  key_name = "EKS_MGT"
  security_groups = ["${aws_security_group.allow_ssh.name}"]
  tags = {
    Name = "TF-WebServer1"
  }
     
}

resource "aws_security_group" "allow_ssh" {
  name  = "webserver-sg"
  description = "Web Servers SG"

  ingress {
      from_port = 22 # By default Linux SSH listen on TCP port 22
      to_port = 22
      protocol = "tcp"

      cidr_blocks = ["76.74.201.36/32","172.31.45.177/32","14.98.83.66/32"]
  }
  ingress {
      from_port = 80 # Allow Web Server access world wide 
      to_port = 80
      protocol = "tcp"

      cidr_blocks = ["76.74.201.36/32"]
  }

  ingress {
      from_port = 80 # Allow Web Server access world wide 
      to_port = 80
      protocol = "tcp"

      security_groups  = ["${aws_security_group.allow_web.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
      }
}


# Create a new load balancer
resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
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
  description = "lbtf sg"

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