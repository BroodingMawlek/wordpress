# alb sg
# allows http from any cidr
# allows egress traffic form any port using any protocol from cidr of wp_private subnets
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "alb to wp private subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.wp_private_subnets
  }
}

# asg sg
# allow 80 to alb_sg
# allow all egress from any cidr block
resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  description = "http to alb_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
# can this be locked down
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# rds sg
# ingress 3306 from asg_sg
# egress no rule needed
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "MySQL from asg_sg"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_sg.id]
  }
}
