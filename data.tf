data "aws_regions" "my_region" {

}
data "aws_ami" "ami_example" {
  most_recent = true
  #owners      = ["ubuntu"]

  filter {
    name   = "name"
    values = ["ubuntu-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# data "aws_availability_zone" "azs" {
# state = "available"

# }