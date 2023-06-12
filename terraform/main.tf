data "yandex_compute_image" "this" {
  name = "${var.image_name}-${var.image_tag}"
}

resource "yandex_compute_instance_group" "this" {
  name                = "${var.name_prefix}-group"
  service_account_id  = yandex_iam_service_account.this.id
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = var.resources.mem
      cores  = var.resources.cpu
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.this.id
        size     = var.resources.disk
      }
    }
    network_interface {
      network_id = yandex_vpc_network.this.id
      #subnet_ids = ["${yandex_vpc_subnet.this["ru-central1-a"].id}"]
      subnet_ids = "${yandex_vpc_subnet.this[*].id}"
    }
    metadata = {
      ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  depends_on = [
    yandex_iam_service_account.this,
    yandex_resourcemanager_folder_iam_binding.this
  ]

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = var.zone
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}