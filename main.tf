resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    name = "terraform_vpc"
  }

}

resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "my_sg"
  tags = {
    name = "my_sg"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_template" "my_lt" {
  instance_type = var.instance_type
  #vpc_security_group_ids = aws_vpc.my_vpc.vpc_security_group_ids
  image_id = data.aws_ami.ami_example.id


}
resource "aws_autoscaling_group" "my_asg" {
  desired_capacity = 1
  min_size         = 1
  max_size         = 2
  launch_template {
    id = aws_launch_template.my_lt.id
  }
  availability_zones = ["us-east-1a"]

}

resource "aws_instance" "terraform_ec2" {
  ami           = data.aws_ami.ami_example.id
  instance_type = var.instance_type
  #security_groups = [aws_security_group.my_sg.name]

  tags = {
    name = "terraform_ec2"
  }
}