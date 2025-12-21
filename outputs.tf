output "admin_access_keys" {
  description = "Admin IAM user access keys"
  value = { for user, key in aws_iam_access_key.admin_key : user => {
    access_key_id     = key.id
    secret_access_key = key.secret
  } }
  sensitive = true
}

output "web_bucket_endpoints" {
  value = {
    for k, b in aws_s3_bucket.web :
    k => aws_s3_bucket_website_configuration.web[k].website_endpoint
  }
  description = "Website endpoints for public web S3 buckets"
}