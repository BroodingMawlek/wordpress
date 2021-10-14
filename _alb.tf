module "alb" {
  source  = "./modules/alb"
  name = "wp-alb"

  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]

  target_groups = [
    {
# optional       name_prefix      = "wp"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]
# target group 0 attaches this listener to the above target group
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

    tags = var.project_tags
}