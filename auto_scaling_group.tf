module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "web_server_asg"

  # Launch configuration
  lc_name = "var.launch_config"

  image_id        = "ami-ebd02392"
  instance_type   = "t2.micro"
  security_groups = ["SG's to access both the public and private ALB's"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "asg_web_servers"
  vpc_zone_identifier       = ["subnet-var.subnet_web_1", "subnet-var.subnet_web2"]
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 4
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      propagate_at_launch = true
    },
  ]
}


module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "application_server_asg"

  # Launch configuration
  lc_name = "var.launch_config"

  image_id        = "ami-ebd02392"
  instance_type   = "t2.micro"
  security_groups = ["SG's to acccess the internal ALB and RDS"]

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "asg_app_servers"
  vpc_zone_identifier       = ["subnet-var.subnet_app_1}", "subnet-var.app_web2}"]
  health_check_type         = "EC2"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 4
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      propagate_at_launch = true
    },
  ]
}