resource "aws_flow_log" "vpc_flow_log" {
    log_destination = var.s3_bucket_arn
    log_destination_type = "s3"
    traffic_type    = "ALL"
    vpc_id = var.vpc_id
    max_aggregation_interval = 60
}