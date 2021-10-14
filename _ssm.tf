resource "aws_ssm_parameter" "cw-ssm" {
  name  = "AmazonCloudWatch-linux"
  type  = "String"
  value = jsonencode(file("./files/AmazonCloudWatch-linux.json"))
   tags = var.project_tags
}
