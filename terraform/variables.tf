####################
# Network settings
####################

variable "network_prefix" {
  type = string
  description = "Prefix name"
  default = "test"
}

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