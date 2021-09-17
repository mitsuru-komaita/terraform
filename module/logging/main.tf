resource "google_logging_project_sink" "google_logging_project_sink" {
  name        = var.name
  description = var.description
  destination = var.destination

  filter = var.filter

  dynamic "exclusions" {
    for_each = var.exclusions
    content {
      disabled    = contains(keys(exclusions.value), "disabled") ? exclusions.value["disabled"] : null
      filter      = exclusions.value.filter
      name        = exclusions.value.name
      description = contains(keys(exclusions.value), "description") ? exclusions.value["description"] : null
    }
  }

  unique_writer_identity = var.unique_writer_identity

  bigquery_options {
    use_partitioned_tables = var.use_partitioned_tables
  }
}

resource "google_project_iam_member" "google_project_iam_member" {
  member     = google_logging_project_sink.google_logging_project_sink.writer_identity
  role       = "roles/bigquery.dataEditor"
  depends_on = [google_logging_project_sink.google_logging_project_sink]
}
