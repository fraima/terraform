resource "vault_policy" "kubernetes-sign-bootstrap" {
  for_each  = "${local.issuers_content_map}"

  name      = "clusters/${var.cluster_name}/certificates/bootstrap-${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("templates/vault/vault-certificate-bootstrap-role.tftpl", { 
    cluster_name        = var.cluster_name
    approle_name        = format("%s",split(":","${each.key}")[1])
    master_instance_list  = local.master_instance_list
    }
  )
}

resource "vault_policy" "kubernetes-sign" {
  for_each  = "${local.issuers_content_map}"

  name      = "clusters/${var.cluster_name}/certificates/${format("%s",split(":","${each.key}")[1])}"

  policy = templatefile("templates/vault/vault-certificate-sign-role.tftpl", { 
    pki_path              = "${local.ssl.intermediate[split(":","${each.key}")[0]].path}",
    cluster_name          = "${var.cluster_name}",
    pki_path_root         = "${local.root_vault_path_pki}",
    base_vault_path_kv    = "${local.base_vault_path_kv}",
    issuer_name           = format("%s",split(":","${each.key}")[1])
    approle_name          = format("%s",split(":","${each.key}")[1])
    master_instance_list  = local.master_instance_list
    }
  )
}