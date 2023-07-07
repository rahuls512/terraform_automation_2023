########### Web-server image ################################################################################################
variable region {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable instance_type {
  description = "instance type to launching AMI"
  type        = string
  default     = "t2.micro"
}

variable ssh_user_name {
  description = "ssh user name for instance"
  type        = string
  default     = "ec2-user"
}

variable app_name {
  description = "app name for web server image"
  type        = string
  default     = "web-server-image"
}
