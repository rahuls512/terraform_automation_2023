# data "amazon-ami" "this" {
#   filters = {
#     virtualization-type = "hvm"
#     root-device-type    = "ebs"
#     name                = "RHEL-9.2.0_HVM-20230503-x86_64-41-Hourly2-GP2"
#   }
#   owners      = ["309956199498"]
#   most_recent = true
#   region      = var.region

# }
