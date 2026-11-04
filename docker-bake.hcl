variable "OPENCODE_VERSION" {
  default = "latest"
}

target "docker-metadata-action" {}

target "build" {
  inherits = ["docker-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile"
  args = {
    OPENCODE_VERSION = OPENCODE_VERSION
  }
  platforms = ["linux/amd64"]
  #network = "host"
}
