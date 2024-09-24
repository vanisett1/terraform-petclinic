resource "aws_launch_template" "asg_launch_template" {
  name_prefix           = "${var.name}-launch-template"
  image_id              = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  # Correct block for IAM Instance Profile
  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<EOF
#!/bin/bash
set -e

# Export environment variables for RDS connection
export DB_HOST="${var.db_host}"
export DB_PORT="5432"
export DB_NAME="petclinicdb"
export DB_USERNAME="petadmin"
export DB_PASSWORD="${var.db_password}"

# Update the system and install Docker and other dependencies
sudo apt update && sudo apt install -y --no-install-recommends curl unzip

# Install AWS CLI v2
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install

# Ensure Docker service is running
sudo systemctl start docker

# Log in to Amazon ECR
sudo aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${var.ecr_registry}

# Pull the Docker image from ECR and run it on port 8080
sudo docker pull ${var.ecr_registry}/${var.ecr_repository}:latest
sudo docker run -d -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=postgres \
  -e DB_HOST=$DB_HOST \
  -e DB_NAME=$DB_NAME \
  -e DB_USERNAME=$DB_USERNAME \
  -e DB_PASSWORD=$DB_PASSWORD \
  ${var.ecr_registry}/${var.ecr_repository}:latest

# CloudWatch Logs configuration
cat <<'EOCONF' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/docker.log",
            "log_group_name": "/aws/petclinic-app",
            "log_stream_name": "{instance_id}/docker.log",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          },
          {
            "file_path": "/var/log/petclinic-app.log",
            "log_group_name": "/aws/petclinic-app",
            "log_stream_name": "{instance_id}/petclinic.log",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOCONF

# Start CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

EOF
)
}


# Create Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  launch_template {
    id      = aws_launch_template.asg_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [var.target_group_arn]

  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}


resource "aws_security_group" "asg_sg" {
  name        = "${var.name}-asg-sg"
  description = "Allow traffic for instances in the ASG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-asg-sg"
  }
}

resource "aws_cloudwatch_log_group" "petclinic_log_group" {
  name              = "/aws/petclinic-app"
  retention_in_days = 7
  tags = {
    Name = "petclinic-log-group"
  }
}


resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# Declare the IAM Role
resource "aws_iam_role" "ec2_instance_role" {
  name = "EC2InstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Attach required policies to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_ecr_ssm_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Declare the IAM Instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_instance_role.name
}
