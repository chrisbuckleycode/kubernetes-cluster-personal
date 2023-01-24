terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "= 2.25.2"
    }
  }
}

# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
# variable "do_token" {}
  # Using instead env variables
  # export/unset DIGITALOCEAN_TOKEN= 
  # export/unset DIGITALOCEAN_ACCESS_TOKEN= 
  # export/unset DO_PAT= 

# Configure the DigitalOcean Provider
provider "digitalocean" {
  # token = var.do_token
}
