# Create IAM Policy for AWS Comprehend
resource "aws_iam_policy" "awscomprehend" {
  name        = "awscomprehend-${local.cluster_name}"
  description = "AWS Comprehend policy for EKS worker nodes"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [{
      "Sid": "AllowDetectActions",
      "Effect": "Allow",
      "Action": [
                "comprehend:DetectEntities",
                "comprehend:DetectKeyPhrases",
                "comprehend:DetectDominantLanguage",
                "comprehend:DetectSentiment",
                "comprehend:DetectSyntax"
             ],   
      "Resource": "*"
      }
   ]
}
EOF
}

# Attach Policy to Role ARN
resource "aws_iam_role_policy_attachment" "aws-comprehend-to-worker-nodes" {
  role       = module.eks.worker_iam_role_name
  policy_arn = aws_iam_policy.awscomprehend.arn
}
