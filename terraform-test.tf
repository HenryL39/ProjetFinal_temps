provider "google" {
    credentials     = "${file("~/Téléchargements/fabled-orbit-241907-8faacd98a4cf.json")}"
    project         = "fabled-orbit-241907"
    region          = "us-central1"
    zone            = "us-central1-a"
}

resource "google_compute_firewall" "firewall" {
  name    = "test-firewall"
  network = "${google_compute_network.vnet.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_subnetwork" "subnet" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region          = "us-central1"
  network       = "${google_compute_network.vnet.self_link}"
}

resource "google_compute_network" "vnet" {
  name = "test-network"
  auto_create_subnetworks = false
}


resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "${google_compute_network.vnet.self_link}"
    subnetwork       = "${google_compute_subnetwork.subnet.self_link}"
    access_config {

    }
  }
}
