rbac:
  create: false
  pspEnabled: false
  pspUseAppArmor: false
  namespaced: false
serviceAccount:
  create: false

replicas: ${ replicas }

## See `kubectl explain poddisruptionbudget.spec` for more
## ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/
podDisruptionBudget: {}
#  minAvailable: 1
#  maxUnavailable: 1

## See `kubectl explain deployment.spec.strategy` for more
## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
deploymentStrategy:
  type: Recreate

readinessProbe:
  httpGet:
    path: /api/health
    port: 3000

livenessProbe:
  httpGet:
    path: /api/health
    port: 3000
  initialDelaySeconds: 60
  timeoutSeconds: 30
  failureThreshold: 10

image:
  repository: grafana/grafana
  tag: "${grafana_version}"
  pullPolicy: IfNotPresent

testFramework:
  enabled: false

securityContext:
  runAsUser: 1472
  runAsGroup: 1472
  fsGroup: 1472

podPortName: grafana

service:
  type: ClusterIP
  port: 80
  targetPort: ${grafana_port}
    # targetPort: 4181 To be used with a proxy extraContainer
  annotations: {}
  labels: {}
  portName: service

%{ if ingress_enabled }
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: 20m
    nginx.ingress.kubernetes.io/proxy-read-timeout: "1800"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "1800"
  path: /
  hosts:
  - ${root_dns}
%{ endif }

resources:
  limits:
    cpu: ${cpu_limit}
    memory: ${memory_limit}
  requests:
    cpu: ${cpu_request}
    memory: ${memory_request}

persistence:
  type: pvc
  enabled: ${pvc_enabled}
  accessModes:
    - ReadWriteOnce
  size: ${pvc_storage_size}
  # annotations: {}
  finalizers:
    - kubernetes.io/pvc-protection

adminUser: ${ admin_user }
adminPassword: ${ admin_password }

plugins: 
  ${ indent(4, yamlencode(plugins)) }

extraConfigmapMounts: 
%{ if dashboard_mounts == null || length( dashboard_mounts ) == 0 }
  []
%{ else }
  %{ for mount in dashboard_mounts ~}
- name: ${mount.basename}
    mountPath: /etc/grafana/provisioning/dashboards/${mount.folderName}/${mount.name}
    subPath: ${mount.name}
    configMap: ${mount.basename}
    readOnly: true
  %{ endfor ~}
%{ endif }

%{ if dashboard_providers == null || length( dashboard_providers ) == 0 }
dashboardProviders: {}
%{ else }
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    ${indent(4, yamlencode(dashboard_providers) )}
%{ endif }

%{ if length( datasources ) != 0 }
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    ${indent(4, yamlencode(datasources) )}
%{ endif }

grafana.ini:
  paths:
    data: /var/lib/grafana/data
    logs: /var/log/grafana
    plugins: /var/lib/grafana/plugins
    provisioning: /etc/grafana/provisioning
  analytics:
    check_for_updates: true
  log:
    mode: console
  grafana_net:
    url: https://grafana.net
%{ if ldap_host != "" }
  auth.ldap:
    enabled: true
    allow_sign_up: true
    config_file: /etc/grafana/ldap.toml
%{ endif }

ldap:
%{ if ldap_host == "" }
  enabled: false
%{ else }
  enabled: true
  config: |
    [[servers]]
    host = "${ ldap_host }"
    port = ${ ldap_port }
    use_ssl = false
    ssl_skip_verify = false
    start_tls = false

    bind_dn = "${ ldap_bind_dn }"
    bind_password = "${ ldap_bind_password }"

    search_filter = "(sAMAccountName=%s)"
    search_base_dns = [ "dc=contiwan,dc=com" ]

    [servers.attributes]
    name = "givenName"
    surname = "sn"
    username = "cn"
    member_of = "memberOf"
    email =  "mail"
%{ endif }