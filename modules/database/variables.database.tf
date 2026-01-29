variable "name" {
  type        = string
  description = "The name of the postgresql database."
}

variable "charset" {
  type        = string
  description = "The charset of the postgresql database."
  default     = "UTF8"
}

variable "collation" {
  type        = string
  description = "The collation of the postgresql database."
  default     = "en_US.utf8"
}

variable "postgresql_server_id" {
  type        = string
  description = "The id of the postgresql server on which to create the database."
}

variable "reader_groups" {
  type = list(object({
    role_prefix = optional(string)
    group_name  = string
  }))
  default = []
}

variable "reader_managed_identity_object_ids" {
  type = list(object({
    object_id      = string
    principal_name = string
    role_prefix    = optional(string)
  }))
  default = []
}

variable "writer_groups" {
  type = list(object({
    group_name  = string
    role_prefix = optional(string)
  }))
  default = []
}

variable "writer_managed_identity_object_ids" {
  type = list(object({
    object_id      = string
    principal_name = string
    role_prefix    = optional(string)
  }))
  default = []
}

variable "admin_groups" {
  type = list(object({
    group_name  = string
    role_prefix = optional(string)
  }))
  default = []
}

variable "admin_identity_object_ids" {
  type = list(object({
    object_id      = string
    principal_name = string
    role_prefix    = optional(string)
  }))
  default = []
}

variable "postgresql_server_administrator_username" {
  type = string
}
