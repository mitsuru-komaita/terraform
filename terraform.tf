terraform {
  backend "local" {
  }
}
variable "PROJECT_ID" {}
variable "PROJECT_NUMBER" {}

provider "google" {
  project = var.PROJECT_ID
  region  = "us-central1"
}

provider "google-beta" {
  project = var.PROJECT_ID
  region  = "us-central1"
}
