resource "aws_athena_workgroup" "production_wg" {
  name = "production_analytics"

  state = "ENABLED"

  configuration {
    enforce_workgroup_configuration = true

    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/results/"
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  tags = {
    Environment = var.env
  }
}
