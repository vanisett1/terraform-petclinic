# Create Load Balancer in public subnets
resource "aws_lb" "public_lb" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]  # Reference the correct SG
  subnets            = var.public_subnets

  tags = {
    Name = var.name
  }
}

# Target Group for Load Balancer
resource "aws_lb_target_group" "main" {
  name        = var.target_group_name
  port        = 8080  # Forwarding to port 8080 (HTTP traffic internally)
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.target_group_name
  }
}

# Listener for HTTP Traffic
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "${var.name}-lb-sg"
  description = "Allow HTTP traffic to the Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "${var.name}-lb-sg"
  }
}
