terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  #credentials = file("./tutorial-project-322811-d9ca21a9c0ab.json")
  credentials = file(var.credentials_file)
  #project = "tutorial-project-322811"
  project = var.project
  #region  = "us-central1"
  region = var.region
  #zone    = "us-central1-c"
  zone = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
    name = "terraform-instance"
    machine_type = "f1-micro"
    tags = ["web", "dev"]
    boot_disk {
        initialize_params {
            #image = "debian-cloud/debian-9"
            image = "cos-cloud/cos-stable"
        }
    }
    network_interface {
        network = google_compute_network.vpc_network.name
        access_config {

        }
    }
}
