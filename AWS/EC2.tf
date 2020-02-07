#--------------------------------------------------------------------
# Define your AWS access
#--------------------------------------------------------------------
provider "aws" {
 
  region   = "${var.region["usregion"]}"
  
  profile = "${var.aws_profile["opsdev"]}"
 
}
#--------------------------------------------------------------------
# Create AWS EC2 Instance
#--------------------------------------------------------------------
resource "aws_instance" webec2 {
 
  ami = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"
  key_name = "${var.key["webserver"]}"
  security_groups = ["${aws_security_group.allow_ssh.name}"]
  tags = {
    Name = "${var.instance_name[0]}"
  }
     
}

#--------------------------------------------------------------------
# Create AWS SG for EC2 Instances and allow access
#--------------------------------------------------------------------

resource "aws_security_group" "allow_ssh" {
  name  = "${var.sg[0]}"
  description = "Web Servers SG"

  ingress {
      from_port = 22 # By default Linux SSH listen on TCP port 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [lookup(var.cidrblock, "vpn")]
      description = "Ciso VPN IP"
  }
  ingress {
      from_port = 22 # By default Linux SSH listen on TCP port 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [lookup(var.cidrblock, "ishir")]
      description = "Amar Office IP"
  }
  ingress {
      from_port = 80 # Allow Web Server access world wide 
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [lookup(var.cidrblock, "vpn")]
      description = "Ciso VPN IP"
  }

  ingress {
      from_port = 80 # Allow Web Server access world wide 
      to_port = 80
      protocol = "tcp"
      security_groups  = ["${aws_security_group.allow_web.id}"]
      description = "${var.lb_name["lb1"]} Access"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "outbound access"
      }
}