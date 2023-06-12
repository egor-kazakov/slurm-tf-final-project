resource "yandex_alb_backend_group" "this" {
  name                     = "backend-group"
  
  http_backend {
    name                   = "http-backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_compute_instance_group.this.application_load_balancer.0.target_group_id]
    load_balancing_config {
      panic_threshold      = 90
    }    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthcheck_port     = 80 
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "this" {
  name   = "http-router"
}

resource "yandex_alb_virtual_host" "this" {
  name           = "virtual-host"
  http_router_id = yandex_alb_http_router.this.id
  route {
    name = "virual-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.this.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "this" {
  name        = "load-balancer"

  network_id  = yandex_vpc_network.this.id

  allocation_policy {
    dynamic "location" {
      for_each = yandex_vpc_subnet.this
      content {
        zone_id   = var.zone[index(yandex_vpc_subnet.this, location.value)]
        subnet_id = location.value.id
      }
    }
  }

  listener {
    name = "listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.this.id
      }
    }
  }
}
