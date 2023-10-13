# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "website_bucket" {
  # Bucket Naming Rules:
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
  # bucket = random_string.bucket_name.result

  # We want to assign a random bucket name.
  #bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${var.public_path}/index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${var.public_path}/index.html")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "error.html"
  source = "${var.public_path}/error.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${var.public_path}/error.html")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_png" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/img/*.{png}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "image/png"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_jpeg" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/img/*.{jpg,jpeg}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "image/jpeg"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_gif" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/img/*.{gif}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "image/gif"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_svg_img" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/img/*.{svg}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "image/svg+xml"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_css" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/css/*.{css}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "text/css"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_js" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/js/*.{js}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "text/javascript"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_eot" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/fonts/*.{eot}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "application/vnd.ms-fontobject"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_svg" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/fonts/*.{svg}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "image/svg+xml"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_ttf" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/fonts/*.{ttf}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "font/ttf"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_woff" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/fonts/*.{woff}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "font/woff"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}
resource "aws_s3_object" "upload_assets_woff2" {
  # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # https://developer.hashicorp.com/terraform/language/functions/fileset
  for_each = fileset(var.public_path, "assets/fonts/*.{woff2}")
  bucket   = aws_s3_bucket.website_bucket.id
  key      = "${each.key}"
  source   = "${var.public_path}/${each.key}"
  content_type = "font/woff2"
  etag     = filemd5("${var.public_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version]
    ignore_changes = [etag]
  }
}

# resource "aws_s3_object" "upload_assets" {
#   # https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
#   # https://developer.hashicorp.com/terraform/language/functions/fileset
#   for_each = fileset(var.public_path, "assets/*.{png,jpg,jpeg,gif,webp,css,js,eot,svg,ttf,woff}")
#   bucket   = aws_s3_bucket.website_bucket.id
#   key      = "${each.key}"
#   source   = "${var.public_path}/${each.key}"
#   etag     = filemd5("${var.public_path}/${each.key}")
#   lifecycle {
#     replace_triggered_by = [terraform_data.content_version]
#     ignore_changes = [etag]
#   }
# }

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.website_bucket.id
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "cloudfront.amazonaws.com"
      },
      "Action" = "s3:GetObject",
      "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
      "Condition" = {
        "StringEquals" = {
          #"AWS:SourceArn" = data.aws_caller_identity.current.arn
          "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
        }
      }
    }
  })
}

# https://developer.hashicorp.com/terraform/language/resources/terraform-data
resource "terraform_data" "content_version" {
  input = var.content_version
}
