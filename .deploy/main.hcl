job chatbot-ui {
  datacenters = ["dc1"]

  group chatbot-ui {
    count = 1
    task chatbot-ui {
      vault {
        policies = ["blockchainr-read-secrets"]
      }
      driver = "docker"
      config {
        image = "acrbc001.azurecr.io/chatbot-ui:latest"
        port_map {
          http = 3000
        }
      }
      template {
        data        = <<EOH
          PORT=3000
        EOH
        destination = "secrets/file.env"
        env         = true
      }
  
      resources {
        cpu    = 512
        memory = 1024
        network {
          port "http" {}
          mbits = 10
        }
      }
      service {
        name = "chatbot-ui"
        tags = [
          "api",
          "urlprefix-chatbot-ui-main.blockchainr.app/"
        ]
        port = "http"
        check {
          name = "alive"
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }
    }
  }

}