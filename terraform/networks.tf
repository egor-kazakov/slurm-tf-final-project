resource "yandex_vpc_network" "this" {
  name = "${var.name_prefix}-network"
}

resource "yandex_vpc_subnet" "this" {
  count = length(var.zone)

  name           = "${var.name_prefix}-${var.zone[count.index]}"
  zone           = var.zone[count.index]
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.cidr_blocks[count.index]
}
