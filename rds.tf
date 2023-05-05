data "aws_kms_key" "by_id" {
  key_id = "example-xxxxxxxxx" # KMS key associated with the CEV
}

#create a security group for RDS Database Instance
resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#create a RDS Database Instance
resource "aws_db_instance" "primary-mysql" {
  engine               = "mysql"
  identifier           = "myrdsinstance"
  allocated_storage    =  20
  engine_version       = "5.7"
  kms_key_id           = data.aws_kms_key.by_id.arn
  instance_class       = "db.t2.micro"
  username             = "myrdsuser"
  password             = "myrdspassword"
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot  = true
  publicly_accessible =  false
  multi_az            =  true
  storage_encrypted   =  true

   timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

resource "aws_db_instance" "read-replica" {
  replicate_source_db         = aws_db_instance.default.identifier
  replica_mode                = "mounted"
  auto_minor_version_upgrade  = false
  backup_retention_period     = 7
  identifier                  = "read-replica"
  instance_class              = "db.t2.micro"
  kms_key_id                  = data.aws_kms_key.by_id.arn
  multi_az                    = true
  skip_final_snapshot         = true
  storage_encrypted           = true

  timeouts {
    create = "3h"
    delete = "3h"
    update = "3h"
  }
}

# I have left out the standby and read replica config in the AZb/subnet 6