# Yandex Cloud nginx VM Image based on Centos 7
#
# Provisioner docs:
# https://www.packer.io/docs/builders/yandex
#

variable "image_tag" {
  type    = string
  default = "1"
}

variable "YC_FOLDER_ID" {
  type    = string
  default = env("YC_FOLDER_ID")
}

variable "YC_ZONE" {
  type    = string
  default = env("YC_ZONE")
}

variable "YC_SUBNET_ID" {
  type    = string
  default = env("YC_SUBNET_ID")
}

packer {
  required_plugins {
    yandex = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/yandex"
    }
  }
}

source "yandex" "nginx" {
  folder_id           = "${var.YC_FOLDER_ID}"
  source_image_family = "centos-7"
  ssh_username        = "centos"
  use_ipv4_nat        = "true"
  image_description   = "Yandex Cloud CentOS 7 nginx image"
  image_family        = "nginx"
  image_name          = "nginx-${var.image_tag}"
  subnet_id           = "${var.YC_SUBNET_ID}"
  disk_type           = "network-hdd"
  zone                = "${var.YC_ZONE}"
}

build {
  sources = ["source.yandex.nginx"]

  provisioner "file" {
    source      = "ansible"
    destination = "/tmp/ansible"
  }

  provisioner "shell" {
    inline = [
      # Install epel-release
      "sudo yum install -y epel-release",

      # Install Ansible
      "sudo yum install -y ansible",

      # Run playbook
      "ansible-playbook /tmp/ansible/playbook.yml",

      # Test - Check versions for installed components
      "echo '=== Tests Start ==='",
      "ansible --version",
      "echo -e",
      "curl http://localhost:80/",
      "echo '=== Tests End ==='"
    ]
  }
}