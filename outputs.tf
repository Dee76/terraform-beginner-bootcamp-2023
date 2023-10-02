# output "random_bucket_name" {
#   value = random_string.bucket_name.result
# }

output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}