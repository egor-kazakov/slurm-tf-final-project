####################
# General settings
####################

variable "name_prefix" {
  type = string
  description = "Prefix name"
  default = "test"
}

variable "YC_FOLDER_ID" {}

####################
# Network settings
####################

variable "cidr_blocks" {
  type = list(list(string))
  description = "cidr subnet"
  default = [
    ["10.10.0.0/24"],
    ["10.20.0.0/24"],
    ["10.30.0.0/24"]
  ]
}

variable zone {
  type = list(string)
  description = "Zones"
  default = [
    "ru-central1-a",
    "ru-central1-b",
    "ru-central1-c"
  ]
}

####################
# PVC settings
####################

variable "image_name" {
  type = string
  description = "Image name PVC tempalte"
  default = "nginx"
}

variable "image_tag" {
  type = string
  description = "Image tag PVC template"
  default = "1"
}

variable "resources" {
  type = object({
    cpu = number
    mem = number
    disk = number
  })
  description = "Hardware resources"
  default = ({
    cpu = 2
    mem = 2
    disk = 10
  })
}