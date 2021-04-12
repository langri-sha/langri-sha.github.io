locals {
  certificate_hash = substr(md5(join(",", values(local.host_subdomains))), 0, 4)
}

resource "google_compute_global_address" "default" {
  name    = "global-address"
  project = module.project_edge.project_id
}

resource "google_dns_managed_zone" "default" {
  name     = "langri-sha"
  dns_name = "${data.terraform_remote_state.org.outputs.org_domain}."
  project  = module.project_edge.project_id
}

resource "google_dns_record_set" "default" {
  for_each = local.host_subdomains

  name    = "${each.value}${google_dns_managed_zone.default.dns_name}"
  project = module.project_edge.project_id

  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [google_compute_global_address.default.address]
  ttl          = 300
  type         = "A"
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name    = "v1-${local.certificate_hash}-ssl-certificate"
  project = module.project_edge.project_id

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = [
      for name in values(local.host_subdomains) : "${name}${google_dns_managed_zone.default.dns_name}"
    ]
  }
}
