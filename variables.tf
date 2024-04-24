variable "job_name" {
  type        = string
  description = "The name of your job"
}

variable "node_pool" {
  type = string
  description = "Where to run your batch job"
}

variable "cron_schedule" {
  type = string
  description = "Batch cron schedule"
}

variable "tfc_organization" {
  type    = string
  description = "The TFCB organization to use"
}

variable "region" {
  type        = string
  description = "The AWS and HCP region to create resources in"
}

variable "stack_id" {
  type = string
}

variable "my_email" {
  type = string
}
