resource "aws_lb" "internet_facing" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["SG's to access the internet as well as the web servers in public subnets 1 & 2"]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = var.environment
  }
}

# I have not included health checks on either of these ALB's !!!

resource "aws_lb" "internal" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["SG's to access the both the web and application servers"]
  subnets            = [for subnet in aws_subnet.private : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "${var.environment}"
  }
}