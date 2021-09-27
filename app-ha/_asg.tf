//launch template
resource "aws_launch_template" "wp" {
  name = "word_press"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }
  disable_api_termination = false
  ebs_optimized = true

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  image_id = "ami-0e80a462ede03e653"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "wordpress_app_layer"
    }
  }

  user_data = filebase64("${path.module}/install_wp.sh")

}

//asg
resource "aws_autoscaling_group" "wp_asg" {
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns  = module.alb.target_group_arns


  launch_template {
    id      = aws_launch_template.wp.id
    version = "$Latest"
  }
}

resource "aws_sns_topic" "cw_alarms" {
  name = "CloudWatch_Alarms"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-over-80-percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wp_asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.cw_alarms.arn]
}

resource "aws_cloudwatch_metric_alarm" "disk_alarm" {
  alarm_name          = "disk-over-80-percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.wp_asg.name
  }

  alarm_description = "This metric monitors ec2 disk utilization"
  alarm_actions       = [aws_sns_topic.cw_alarms.arn]
}

//Lambda function
resource "aws_lambda_function" "delete_alarms" {
  s3_bucket     = "byoi-lambda-function"
  s3_key        = "delete_alarms.zip"
  function_name = "delete_alarms"
  role          = aws_iam_role.lifecycle_role.arn
  handler       = "invite_accounts_to_org.lambda_handler"
  runtime = "python3.7"
  timeout = "300"

  environment {
    variables = {
      foo = "bar"
    }
  }
}