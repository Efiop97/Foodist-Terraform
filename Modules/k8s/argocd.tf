resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.52.1"
  
  values = [
    "${file(var.values_path)}"
  ]
}

resource "kubectl_manifest" "main_cd" {
  depends_on = [helm_release.argocd, kubernetes_secret.foodist_gitops_repo_cred]

  yaml_body = file(var.main_cd_path)
}