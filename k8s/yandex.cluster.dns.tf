locals {
  etcd_member_servers_srv = flatten([
    for master_name, master_value in yandex_compute_instance.master: [
     "0 0 ${var.etcd-peer-port} ${var.master-configs.group}-${index(keys(yandex_compute_instance.master), master_name)}.${var.cluster_name}.${var.base_domain}."
    ]
  ])
  etcd_member_clients_srv = flatten([
    for master_name, master_value in yandex_compute_instance.master: [
     "0 0 ${var.etcd-server-port} ${var.master-configs.group}-${index(keys(yandex_compute_instance.master), master_name)}.${var.cluster_name}.${var.base_domain}."
    ]
  ])
}

#### DNS ######
##-->
resource "yandex_dns_zone" "cluster-external" {
  name             = "dns-zone-${var.cluster_name}"
  description      = "desc"
  zone             = "${var.cluster_name}.${var.base_domain}."
  public           = false
  private_networks = [yandex_vpc_network.cluster-vpc.id]
}

# resource "yandex_dns_recordset" "master" {
#   for_each  = "${var.availability_zones}"
#   zone_id   = yandex_dns_zone.cluster-external.id
#   name      = "${var.master-configs.group}-${index(keys(var.availability_zones), each.key)}.${var.cluster_name}.${var.base_domain}."
#   type      = "A"
#   ttl       = 60
#   data      = ["${yandex_compute_instance.master[each.key].network_interface.0.ip_address}"]
# }

resource "yandex_dns_recordset" "api" {
  zone_id = yandex_dns_zone.cluster-external.id
  name    = "${local.kube_apiserver_lb_fqdn}."
  type    = "A"
  ttl     = 60
  data    = "${(tolist(yandex_lb_network_load_balancer.api-internal.listener)[0].external_address_spec)[*].address}"
}

resource "yandex_dns_recordset" "etcd" {
  zone_id = yandex_dns_zone.cluster-external.id
  name    = "${local.etcd_server_lb_fqdn}."
  type    = "A"
  ttl     = 60
  data    = "${(tolist(yandex_lb_network_load_balancer.etcd-internal.listener)[0].internal_address_spec)[*].address}"
}

resource "yandex_dns_recordset" "etcd-srv-server" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-server-ssl._tcp.${var.cluster_name}.${var.base_domain}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_servers_srv
}

resource "yandex_dns_recordset" "etcd-srv-client" {
  zone_id   = yandex_dns_zone.cluster-external.id
  name      = "_etcd-client-ssl._tcp.${var.cluster_name}.${var.base_domain}."
  type      = "SRV"
  ttl       = 60
  data      = local.etcd_member_clients_srv
}
