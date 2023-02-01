
cidr = {
    service = "29.64.0.0/16"
    pod = "10.103.0.0/16"
    node_cidr_mask = "24"
}
cluster_name = "cluster-3"
default_subnet = "10.3.0.0/30"
default_zone = "ru-central1-a"

vault_server = "http://193.32.219.99:9200/"

yandex_cloud_name = "cloud-uid-vf465ie7"

yandex_folder_name = "example"

yandex_default_vpc_name = "vpc.clusters"

yandex_default_route_table_name = "vpc-clusters-route-table"

base_domain = "dobry-kot.ru"

master_group = {
    count = 1
}
