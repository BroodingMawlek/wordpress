#######
# alb sg
#######
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "alb_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# -1 = all
# allows traffic from all ports and all protocols to 2 x private subnets for wp server
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.vpc_private_subnets
  }

}

#######
# asg sg
#######
resource "aws_security_group" "asg_sg" {
  name        = "asg_sg"
  description = "asg_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#######
# rds sg
#######
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http from internet"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_sg.id]
  }

}
