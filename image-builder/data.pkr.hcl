# data "amazon-ami" "this" {
#   filters = {
#     virtualization-type = "hvm"
#     name                = "RHEL-9.2.0-*"
#     root-device-type    = "ebs"
#   }
#   owners      = ["309956199498"]
#   most_recent = true
#   region      = var.region

# }
