terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.6.0"
}

provider "docker" {
host = "unix:///var/run/docker.sock"
}

resource "docker_network" "app_network" {
  name = "${var.project_name}_network"
}

resource "docker_volume" "app_volume" {
  name = "${var.project_name}_data"
}

resource "docker_image" "php" {
  name = "php:fpm-alpine"
}

resource "docker_container" "php_fpm" {
  name  = "php-fpm"
  image = docker_image.php.image_id
  
  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.app_volume.name
    container_path = "/var/www/html"
  }

  upload {
    content = file("${path.cwd}/../generated_config/index.php")
    file    = "/var/www/html/index.php"
  }
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "nginx" {
  name  = "${var.project_name}_nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.host_port
  }

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.app_volume.name
    container_path = "/var/www/html"
    read_only      = true
  }

  volumes {
    host_path      = abspath("${path.cwd}/../generated_config/nginx.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
  }
}
