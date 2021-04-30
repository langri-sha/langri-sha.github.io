locals {
  certificate_hash = substr(md5(join(",", values(local.host_names))), 0, 4)
}

resource "google_compute_global_address" "default" {
  name    = "global-address"
  project = module.project_edge.project_id
}

resource "google_dns_managed_zone" "default" {
  name     = "langri-sha"
  dns_name = "${local.org_domain}."
  project  = module.project_edge.project_id
}

resource "google_dns_record_set" "default" {
  for_each = local.host_names

  name    = "${each.value}."
  project = module.project_edge.project_id

  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = [google_compute_global_address.default.address]
  ttl          = 300
  type         = "A"
}

resource "google_dns_record_set" "site_verifications" {
  count = length(local.site_verifications) > 0 ? 1 : 0

  name    = google_dns_managed_zone.default.dns_name
  project = module.project_edge.project_id

  managed_zone = google_dns_managed_zone.default.name
  rrdatas      = local.site_verifications
  ttl          = 300
  type         = "TXT"
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name    = "v1-${local.certificate_hash}-ssl-certificate"
  project = module.project_edge.project_id

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = values(local.host_names)
  }
}

resource "google_compute_backend_bucket" "public" {
  for_each = toset(compact([
    for host in local.hosts : contains(keys(local.host_redirects), host) ? "" : host
  ]))

  name    = "${each.value}-backend-bucket"
  project = module.project_edge.project_id

  bucket_name = google_storage_bucket.public[each.value].name
  enable_cdn  = true
}
