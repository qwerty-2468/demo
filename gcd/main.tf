# 1. Configure the Google Cloud Provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "qwerty-devops-project-123" # Put your exact GCP Project ID here
  region  = "us-central1"
  zone    = "us-central1-a"
}

# 2. Create a Firewall rule to allow HTTP web traffic (Port 80)
resource "google_compute_firewall" "web_firewall" {
  name    = "allow-devops-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"] # <-- Added 8080 here for Jenkins
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}

# 1. Create an independent, permanent storage disk for Jenkins data

# 2. Update your existing VM definition to attach the disk
resource "google_compute_instance" "vm_instance" {
  name         = "devops-free-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["web-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  # This block tells GCP to wire the persistent storage disk to this new VM instance
  attached_disk {
    source      = "jenkins-persistent-storage"
    device_name = "jenkins-data"
  }

  network_interface {
    network = "default"
    access_config {}
  }
}


# 4. Output the public IP address of your new Google Cloud VM
output "gcp_public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

# This resource automatically generates your Ansible inventory file
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/hosts.ini"
  content  = <<EOT
[gcp_nodes]
gcp-node ansible_host=${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} ansible_user=qwerty ansible_ssh_private_key_file=~/.ssh/google_compute_engine
EOT
}