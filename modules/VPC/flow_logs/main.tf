# Define an AWS VPC flow log and attach it to our bucket every 10 min
resource "aws_flow_log" "vpc_flow_log" {
    for_each = var.vpc_id
    log_destination         = var.s3_bucket_arn
    log_destination_type    = "s3"
    traffic_type            = "ALL"
    vpc_id                  = each.value
    max_aggregation_interval = 600
}
