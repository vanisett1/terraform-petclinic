# RDS Subnet Group across 2 AZs
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-cluster-subnet-group"
  subnet_ids = var.private_subnets
  description = "RDS cluster subnet group across 2 AZs"

  tags = {
    Name = "rds-cluster-subnet-group"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-cluster-sg"
  description = "Allow EC2 to connect to RDS Cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Cluster (Aurora with PostgreSQL)
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "petclinic-db-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "13.7"
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  apply_immediately       = true

  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
}

# RDS Cluster Instance (Primary in 1 AZ)
resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier              = "petclinic-db-instance-1"
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = "db.t3.medium"
  engine                  = aws_rds_cluster.aurora_cluster.engine
  engine_version          = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible     = false
  apply_immediately       = true
  availability_zone       = "us-east-1a"
}

