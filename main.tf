resource "helm_release" "grafana_helm" {
  name                       = var.DEPLOYMENT_NAME
  repository                 = "https://grafana.github.io/helm-charts"
  chart                      = "grafana"
  version                    = var.CHART_VERSION
  namespace                  = var.NAMESPACE
  timeout                    = 300
  values                     = [ templatefile("${path.module}/values.tpl", {
    grafana_version = var.GRAFANA_VERSION
    grafana_port    = var.GRAFANA_PORT
    root_dns        = var.ROOT_DNS
    ingress_enabled = var.INGRESS_ENABLED
    pvc_enabled       = var.PVC_ENABLED
    pvc_storage_size  = var.PVC_STORAGE_SIZE
    cpu_request       = var.CPU_REQUEST
    cpu_limit         = var.CPU_LIMIT
    memory_request    = var.MEMORY_REQUEST
    memory_limit      = var.MEMORY_LIMIT
    ldap_base_dn          = var.LDAP_BASE_DN
    plugins               = var.PLUGINS
    admin_user      = var.ADMIN_USER
    admin_password  = var.ADMIN_PASSWORD
    ldap_bind_dn      = var.LDAP_BIND_DN
    ldap_bind_password = var.LDAP_BIND_PASSWORD
    ldap_host       = var.LDAP_HOST
    ldap_port       = var.LDAP_PORT
    replicas       = var.REPLICAS
    dashboard_providers   = var.DASHBOARD_PROVIDER
    dashboard_mounts  = var.DASHBOARD_MOUNTS
    datasources = var.DATA_SOURCES
  })]

  depends_on = [var.GRAFANA_DEPENDS_ON]
}

