output balancer {
    value = yandex_alb_load_balancer.this.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output pvc {
    value = yandex_compute_instance_group.this.instances[*].network_interface[0].nat_ip_address
}