resource "aws_glue_catalog_database" "athena_db" {
  name        = "analytics_db_${var.env}"
  description = "Athena database for analytics pipeline"
}

resource "aws_glue_catalog_table" "example_table" {
  name          = "events_table"
  database_name = aws_glue_catalog_database.athena_db.name

  table_type = "EXTERNAL_TABLE"

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.data_lake.bucket}/events/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "OpenCSVSerde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim"             = ","
        "skip.header.line.count"  = "1"
      }
    }

    columns {
      name = "event_id"
      type = "string"
    }

    columns {
      name = "event_timestamp"
      type = "timestamp"
    }

    columns {
      name = "user_id"
      type = "string"
    }
  }

  parameters = {
    classification = "csv"
    typeOfData     = "file"
  }
}

resource "aws_glue_crawler" "events_crawler" {
  name          = "events-crawler-${var.env}"
  role          = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.athena_db.name
  description   = "Crawler that scans S3 events data and updates Glue Catalog table automatically"

  s3_target {
    path = "s3://${aws_s3_bucket.data_lake.bucket}/events/"
  }

  schedule = "cron(0 * * * ? *)"

  tags = merge(local.common_tags, {
    Name = "Glue Events Crawler"
  })
}
