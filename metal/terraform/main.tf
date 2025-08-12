resource "docker_image" "dnsmasq" {
    name    = "jpillora/dnsmasq:latest"
}

resource "docker_container" "dnsmasq" {
  name      = "dnsmasq"
  image     = docker_image.dnsmasq.name
  restart   = "unless-stopped"

  ports {
    internal = 53
    external = 53
    protocol = "tcp"
  }

  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }

  volumes {
    host_path      = abspath("${path.module}/files/dnsmasq/dnsmasq.conf")
    container_path = "/etc/dnsmasq.conf"
  }
}