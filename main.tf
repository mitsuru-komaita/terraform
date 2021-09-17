module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.1"

  project_id = var.PROJECT_ID
  activate_apis = [
    "appengine.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "logging.googleapis.com",
  ]
}

resource "google_app_engine_application" "app" {
  project     = var.PROJECT_ID
  location_id = "us-central"
}

resource "google_project_iam_member" "google_project_iam_member" {
  for_each = local.iam_members
  member   = each.value.member
  role     = each.value.role

  depends_on = [module.project-services]
}

resource "google_bigquery_dataset" "dataset" {
  for_each   = local.bq_dataset
  dataset_id = each.value.bigquery_dataset_name
  location   = each.value.location
}

resource "google_cloudbuild_trigger" "google_cloudbuild_trigger" {
  for_each       = local.cloudbuild_triggers
  name           = each.value.name
  description    = each.value.description
  filename       = each.value.filename
  included_files = contains(keys(each.value), "included_files") ? each.value["included_files"] : []
  ignored_files  = contains(keys(each.value), "ignored_files") ? each.value["ignored_files"] : []
  tags           = each.value.tags
  substitutions  = contains(keys(each.value), "substitutions") ? each.value["substitutions"] : {}
  dynamic "github" {
    for_each = contains(keys(each.value), "github") ? each.value["github"] : []
    content {
      name  = github.value.name
      owner = github.value.owner
      push {
        branch       = github.value.branch
        invert_regex = github.value.invert_regex

      }
    }
  }
  depends_on = [module.project-services]
}

module "logging_sink" {
  source      = "./module/logging/"
  for_each    = local.google_logging_project_sinks
  name        = each.value.name
  destination = each.value.destination
  filter      = each.value.filter

  depends_on = [module.project-services, google_bigquery_dataset.dataset]
}
