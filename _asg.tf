#Auto Scaling Group
resource "aws_autoscaling_group" "wp_asg" {
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  vpc_zone_identifier = module.vpc.private_subnets
  target_group_arns  = module.alb.target_group_arns

  launch_template {
    id      = aws_launch_template.wordpress-launch-template.id
    version = "$Latest"
  }
}

#launch template
resource "aws_launch_template" "wordpress-launch-template" {
  name = "word_press"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
# can use reserved instance if available
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
# type of burst cpu
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
# If true, the launched EC2 instance will have detailed monitoring enabled, 1 minute period
  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  tag_specifications {
    resource_type = "instance"

      tags = var.project_tags
  }
# Make sure bucket is correct install_wp.sh or wp-config.php will not copy
  user_data = filebase64("${path.module}/files/install_wp.sh")

}

#sns topic
resource "aws_sns_topic" "cw_alarms" {
  name = "CloudWatch_Alarms"
}

#cpu alarm
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

#disk alarm
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
