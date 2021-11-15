terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

variable "SSH_KEY" {
  type = string
  sensitive   = true
}

data "template_file" "user_data" {
  template = file("./dio-setup.yaml")
}

resource "digitalocean_ssh_key" "Thunt-key" {
  name       = "Thunt-key"
  public_key = var.SSH_KEY
}

# Create a droplet
resource "digitalocean_droplet" "Thunt" {
    image = "ubuntu-18-04-x64"
    name = "Thunt"
    region = "nyc1"
    size = "s-1vcpu-1gb"
    tags = ["Learn-Thunt"]
    user_data = data.template_file.user_data.rendered
    ssh_keys = [digitalocean_ssh_key.Thunt-key.fingerprint]
}

output "public_ip" {
  value = digitalocean_droplet.Thunt.ipv4_address
}