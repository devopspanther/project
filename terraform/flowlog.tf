resource "aws_flow_log" "flowlog" {
# BEGIN ANSIBLE MANAGED BLOCK
  log_destination      = "arn:aws:s3:::dsolab-security-log"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = module.vpc.vpc_id
# END ANSIBLE MANAGED BLOCK
}