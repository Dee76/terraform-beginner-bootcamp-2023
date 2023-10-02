variable "user_uuid" {
  type        = string
  description = "Unique User UUID"
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "Invalid user_uuid format. It should be in the format of a UUID (e.g., '123e4567-e89b-12d3-a456-426655440000')."
  }
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 Bucket Name"
  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Invalid bucket_name format. It should be between 3 and 63 characters in length, containing only lowercase alphanumeric characters, hyphens, or periods, and must not start or end with a hyphen or period."
  }
}
