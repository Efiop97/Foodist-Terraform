data "aws_secretsmanager_secret" "foodist_gitops_repo_cred_secret" {
  arn = "arn:aws:secretsmanager:us-east-1:644435390668:secret:FoodistGitOps-y2BiD0"
}

data "aws_secretsmanager_secret_version" "foodist_gitops_repo_cred_current" {
  secret_id = data.aws_secretsmanager_secret.foodist_gitops_repo_cred_secret.id
}

resource "kubernetes_secret" "foodist_gitops_repo_cred" {
  depends_on = [helm_release.argocd]

  metadata {
    name      = "foodist-gitops-repo-cred"
    namespace = "argocd"

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    name          = "foodist-gitops-repo-cred"
    type          = "git"
    url           = "git@github.com:Efiop97/Foodist-GitOps.git"
    sshPrivateKey = data.aws_secretsmanager_secret_version.foodist_gitops_repo_cred_current.secret_string
  }
}


resource "kubernetes_namespace" "foodist" {
  metadata {
    name = "foodist"
  }
}