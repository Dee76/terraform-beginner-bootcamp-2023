output "lebowksi_bucket_name" {
  description = "Bucket name for our static website hosting for the Lebowski TerraHome."
  value = module.home_lebowski_hosting.bucket_name
}

output "lebowski_s3_website_endpoint" {
  description = "S3 Static Websit hosting endpoint for the Lebowski TerraHome."
  value = module.home_lebowski_hosting.website_endpoint
}

output "lebowski_domain_name" {
  description = "CloudFront Distribution domain name for the Lebowski TerraHome."
  value = module.home_lebowski_hosting.domain_name
}

output "gfcake_bucket_name" {
  description = "Bucket name for our static website hosting for the Lebowski TerraHome."
  value = module.home_gfcake_hosting.bucket_name
}

output "gfcake_s3_website_endpoint" {
  description = "S3 Static Websit hosting endpoint for the Lebowski TerraHome."
  value = module.home_gfcake_hosting.website_endpoint
}

output "gfcake_domain_name" {
  description = "CloudFront Distribution domain name for the Lebowski TerraHome."
  value = module.home_gfcake_hosting.domain_name
}