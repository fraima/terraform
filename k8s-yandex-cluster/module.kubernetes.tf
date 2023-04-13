module "kubernetes" {
    source = "git::https://github.com/fraima/terraform-modules//modules/k8s-yandex-cluster-infra?ref=v1.0.4"

    global_vars     = local.custom_global_vars_merge
    cloud_metadata  = var.cloud_metadata
    master_group    = local.master_group_merge
}
