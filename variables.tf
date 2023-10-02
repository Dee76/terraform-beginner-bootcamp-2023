variable "user_uuid" {
  type        = string
  description = "Unique User UUID"
  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "Invalid user_uuid format. It should be in the format of a UUID (e.g., '123e4567-e89b-12d3-a456-426655440000')."
  }
}