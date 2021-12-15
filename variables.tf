variable "CHART_VERSION" {}

variable "GRAFANA_PORT" {}

variable "NAMESPACE" {}

variable "INGRESS_ENABLED" {}

variable "ROOT_DNS" {}

variable "DEPLOYMENT_NAME" {}

variable "GRAFANA_VERSION" {}

variable "PLUGINS" {}

variable "PVC_ENABLED" {}

variable "PVC_STORAGE_SIZE" {}

variable "CPU_LIMIT" {}

variable "CPU_REQUEST" {}

variable "MEMORY_LIMIT" {}

variable "MEMORY_REQUEST" {}

variable "REPLICAS" {}

variable "LDAP_BASE_DN" {}

variable "DATA_SOURCES" {}

variable "DASHBOARD_MOUNTS" {}

variable "DASHBOARD_PROVIDER" {}

variable "ADMIN_USER" {}

variable "ADMIN_PASSWORD" {}

variable "LDAP_BIND_DN" {}

variable "LDAP_BIND_PASSWORD" {}

variable "LDAP_HOST" {}

variable "LDAP_PORT" {}

variable "GRAFANA_DEPENDS_ON" {
    type    = any
    default = []
}