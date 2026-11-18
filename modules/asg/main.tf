data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}
resource "aws_launch_template" "app" {

  name_prefix = "app-template"

  image_id = data.aws_ami.amazon_linux.id

  instance_type = "t3.micro"

  vpc_security_group_ids = [
    var.app_sg_id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash

yum update -y

yum install -y docker

systemctl start docker
systemctl enable docker

docker pull saiperam19/aws-ha-project:v1

docker run -d \
--name aws-ha-project \
-p 80:80 \
saiperam19/aws-ha-project:v1

EOF
  )
}
resource "aws_autoscaling_group" "app_asg" {

  min_size = 2
  max_size = 4

  desired_capacity = 2

  vpc_zone_identifier = [
    var.private_subnet1_id,
    var.private_subnet2_id
  ]

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {

    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }
}