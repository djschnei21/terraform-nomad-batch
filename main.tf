terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "~> 3.18.0"
    }

    nomad = {
      source = "hashicorp/nomad"
      version = "2.0.0-beta.1"
    }
  }
}

data "terraform_remote_state" "nomad_cluster" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = "5_nomad-cluster"
    }
  }
}

provider "vault" {}

data "vault_kv_secret_v2" "bootstrap" {
  mount = data.terraform_remote_state.nomad_cluster.outputs.bootstrap_kv
  name  = "nomad_bootstrap/SecretID"
}

provider "nomad" {
  address = data.terraform_remote_state.nomad_cluster.outputs.nomad_public_endpoint
  secret_id = data.vault_kv_secret_v2.bootstrap.data["SecretID"]
}

resource "nomad_job" "batch" {
  hcl2 {
    vars = {
      job_name = var.job_name
      node_pool = var.node_pool
      cron_schedule = var.cron_schedule
    }
  }
  jobspec = file("${path.module}/batch.hcl")
}



