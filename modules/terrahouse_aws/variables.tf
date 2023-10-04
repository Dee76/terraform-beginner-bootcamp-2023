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

variable "index_html_filepath" {
  type        = string
  description = "File path to the index.html file"
  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified file path does not exist."
  }
}

variable "error_html_filepath" {
  type        = string
  description = "File path to the error.html file"
  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified file path does not exist."
  }
}

variable "content_version" {
  type        = number
  description = "Content version (positive integer starting at 1)"
  validation {
    condition     = var.content_version > 0 && ceil(var.content_version) == floor(var.content_version)
    error_message = "Content version must be a positive integer starting at 1."
  }
}
