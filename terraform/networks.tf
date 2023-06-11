resource "yandex_vpc_network" "this" {
  name = "${var.network_prefix}-network"
}

resource "yandex_vpc_subnet" "this" {
  for_each = toset(var.zone)

  name           = "${var.network_prefix}-${each.value}"
  zone           = each.value
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.cidr_blocks[index(var.zone, each.value)]
}
