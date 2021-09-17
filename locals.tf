locals {
  bq_dataset = {
    rawdata = {
      bigquery_dataset_name = "rawdata"
      location              = "US"
    }
  }

  iam_members = {
    gae = {
      member = "serviceAccount:${var.PROJECT_ID}@appspot.gserviceaccount.com"
      role   = "roles/appengine.appAdmin"
    },
    cloudbuild_gae_1 = {
      member = "serviceAccount:${var.PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
      role   = "roles/appengine.appAdmin"
    },
    cloudbuild_gae_2 = {
      member = "serviceAccount:${var.PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
      role   = "roles/iam.serviceAccountUser"
    },
    cloudbuild_gae_3 = {
      member = "serviceAccount:${var.PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
      role   = "roles/compute.storageAdmin"
    },
    cloudbuild_gae_4 = {
      member = "serviceAccount:${var.PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"
      role   = "roles/cloudbuild.builds.editor"
    }
  }

  cloudbuild_triggers = {
    nodejs = {
      name        = "nodejs"
      description = "nodejs"
      filename    = "nodejs/cloudbuild.yaml"
      included_files = [
        "nodejs/**",
      ]
      tags = [
        "github-default-push-trigger",
      ]
      github = [{
        name         = "terraform"
        owner        = "mitsuru-komaita"
        branch       = "^main$"
        invert_regex = false
        }
      ]
    }
  }

  google_logging_project_sinks = {
    logging_sink_to_bigquery = {
      name        = "logging_sink_to_bigquery"
      destination = "bigquery.googleapis.com/${google_bigquery_dataset.dataset["rawdata"].id}"
      filter      = <<-EOT
          resource.type = "gae_app"
          jsonPayload.level="info"
          logName="projects/${var.PROJECT_ID}/logs/stdout"
        EOT
      bigquery_options = [
        {
          use_partitioned_tables = true
        }
      ]
    }
  }
}
