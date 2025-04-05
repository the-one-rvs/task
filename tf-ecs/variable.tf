variable "pg_user" {
  description = "PostgreSQL user"
  type        = string
}

variable "pg_host" {
  description = "PostgreSQL host"
  type        = string
}

variable "pg_database" {
  description = "PostgreSQL database name"
  type        = string
}

variable "pg_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "pg_port" {
  description = "PostgreSQL port"
  type        = string
}

variable "tag" {
  description = "Docker image tag"
  type        = string
}