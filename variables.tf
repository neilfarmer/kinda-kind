variable "wildcard_domain_name" {
  type = string
}

variable "gitlab_runner_token" {
  type = string
  # sensitive = true
  default = "none"
}