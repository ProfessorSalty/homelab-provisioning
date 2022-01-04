variable "PUID" {
  type = number
  default = 1000
}

variable "GUID" {
  type = number
  default = 1000
}

variable "TZ" {
  type = string
}

job "mediaserver" {
  datacenters = [var.datacenter]

  type = "service"

  constraint {
    attr = "{{meta.machinename}}"
    value = "mediaserver"
  }

  group "mediaserver" {
    count = 1

    volume "media" {
      type = "host"
      source = "media"
    }

    volume "books" {
      type = "host"
      source = "books"
    }

    volume "music" {
      type = "host"
      source = "music"
    }

    volume "podcasts" {
      type = "host"
      source = "podcasts"
    }

    volume "jellyfin_config" {
      type = "host"
      source = "jellyfin_config"
    }

    volume "airsonic_config" {
      type = "host"
      source = "airsonic_config"
    }

    volume "airsonic_playlists" {
      type = "host"
      source = "airsonic_playlists"
    }

    volume "calibre_web_config" {
      type = "host"
      source = "calibre_web_config"
    }

    task "jellyfin" {
      driver = "{{var.driver}}"

      volume_mount {
        volume = "jellyfin_config"
        destination = "/jellyfin/config"
      }

      volume_mount {
        volume = "media"
        destination = "/media/media"
      }

      config {
        image = "lscr.io/linuxserver/jellyfin"
        port_map = {
          jellyfin_http = 8096
          client_discovery = 7359
        }
      }

      env {
        PUID = "{{var.PUID}}"
        GUID = "{{var.GUID}}"
        TZ = "{{var.TZ}}"
        JELLYFIN_PublishedServerUrl = ""
      }

      service {
        name = "jellyfin"
        port = "jellyfin_http"
        tags = ["media", "movies"]
        check {
          name     = "Jellyfin health using http endpoint '/health'"
          port     = "jellyfin_http"
          type     = "http"
          path     = "/health"
          method   = "GET"
          interval = "10s"
          timeout  = "2s"
        }
      }

      network {
        port "jellyfin_http" {}
        port "client_discovery" {}
      }
    }

    task "airsonic" {
      driver = "{{var.driver}}"

      volume_mount {
        volume = "airsonic_config"
        destination = "/var/airsonic"
      }

      volume_mount {
        volume = "music"
        destination = "/var/music"
      }

      volume_mount {
        volume = "podcasts"
        destination = "/var/podcasts"
      }

      volume_mount {
        volume = "airsonic_playlists"
        destination = "/var/playlists"
      }

      config {
        image = "lscr.io/linuxserver/airsonic"
        port_map = {
          airsonic_http = 4040
        }
      }

      env {
        PUID = "{{var.PUID}}"
        GUID = "{{var.GUID}}"
        TZ = "{{var.TZ}}"
      }

      service {
        name = "airsonic"
        port = "airsonic_http"
        tags = ["media", "music"]
        check {
          name     = "Airsonic health using http endpoint '/ping'"
          port     = "airsonic_http"
          type     = "http"
          path     = "/rest/ping"
          method   = "GET"
          interval = "10s"
          timeout  = "2s"
        }
      }

      network {
        port "airsonic_http" {}
      }
  }

    task "calibre-web" {
      driver = "{{var.driver}}"

      volume_mount {
        volume = "books"
        destination = "/books"
      }

      volume_mount {
        volume = "calibre_web_config"
        destination = "/config"
      }

      config {
        image = "lscr.io/linuxserver/calibre-web"
        port_map = {
          calibre_web_http = 8083
        }
      }

      env {
        PUID = "{{var.PUID}}"
        GUID = "{{var.GUID}}"
        TZ = "{{var.TZ}}"
        DOCKER_MODS = "linuxserver/calibre-web:calibre"
      }

      service {
        name = "calibre-web"
        port = "calibre_web_http"
        tags = ["media", "books"]

        check {
          name     = "calibre-web health using GET requests to index"
          port     = "calibre_web_http"
          type     = "http"
          path     = "/"
          method   = "GET"
          interval = "60s"
          timeout  = "1s"
        }
      }

      network {
        port "calibre_web_http" {}
      }
    }
  }
