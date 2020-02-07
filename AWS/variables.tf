variable "aws_profile" {
    type = map
    default = {
        "opsdev" = "default"
    }
}

variable "instance_name" {
    type = list
    default = ["server1","server2","server3"]
        
}

variable "lb_name" {
    type = map
    default = {
        "lb1" = "myfirstlb"
        "lb2" = "mysecondlb"
        "lb3" = "mythirdlb"
    }
}

variable "sg" {
    type = list
    default = [ "websg", "lbsg"]
        
}

variable "region" {
    type = map
    default = {
        "usregion" = "us-east-1"
    }
}

variable "key" {
    type = map
    default = {
        "webserver" = "EKS_MGT"
    }
}

variable "cidrblock" {
    type = map
    default = {
        office ="172.31.45.177/32"
        vpn = "76.74.201.36/32"
        ishir = "14.98.83.66/32"
    }
    
    
}

