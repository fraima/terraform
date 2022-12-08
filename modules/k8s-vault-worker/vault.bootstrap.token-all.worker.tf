

resource "vault_token_auth_backend_role" "kubernetes-all-bootstrap-worker" {
  for_each                  = var.worker_instance_list_map
  role_name                 = "all-${each.key}"
  allowed_policies          = [vault_policy.kubernetes-all-bootstrap-worker[each.key].name]
  token_period              = "0"
  renewable                 = false
  allowed_entity_aliases    = []
  allowed_policies_glob     = []
  disallowed_policies       = []
  disallowed_policies_glob  = []
  token_bound_cidrs         = []
  token_policies            = []
  orphan                    = false
  token_type                = "default-service"
}


resource "vault_token" "kubernetes-all-login-bootstrap-worker" {
  for_each  = var.worker_instance_list_map
  role_name = vault_token_auth_backend_role.kubernetes-all-bootstrap-worker[each.key].role_name
  policies  = vault_token_auth_backend_role.kubernetes-all-bootstrap-worker[each.key].allowed_policies
  metadata  = {}
  ttl = "0"

}

