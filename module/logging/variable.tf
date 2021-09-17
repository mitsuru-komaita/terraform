variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "destination" {
  type = string
}

variable "filter" {
  type    = string
  default = null
}

variable "exclusions" {
  type    = list(map(string))
  default = []
}

variable "unique_writer_identity" {
  type    = bool
  default = true
}

variable "bigquery_options" {
  type    = list(map(string))
  default = []
}

variable "use_partitioned_tables" {
  type    = bool
  default = true
}
