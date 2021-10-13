# Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name       = "ec2_profile_byoi"
  role       = aws_iam_role.ec2_role.name
}

# Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role_byoi"

assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
EOF
}
# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach-cloudwatch-policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach-ssm-policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach-s3-policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach-secrets-manager-policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

