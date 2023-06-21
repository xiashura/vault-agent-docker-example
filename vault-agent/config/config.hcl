pid_file = "./pidfile"

//auth method
auto_auth {
  method {
    type = "approle"

    config = {
      role_id_file_path = "/vault-agent/roleid"
      secret_id_file_path = "/vault-agent/secretid"
      remove_secret_id_file_after_reading = false
    }
  }

  sink {
    type = "file"
    config = {
      path = "/vault-agent/token"
    }
  }
}
// setting template
template_config {
  static_secret_render_interval = "1m"
}


template {
  // exec command into pod or container vault agent
  exec = {
    command = [
      "curl -X GET -H \"Content-Type: application/json\" -d @/usr/share/app.json http://test-webhook:8080/"
    ]
  }

  source = "/vault-agent/env.tpl"
  destination = "/usr/share/app.json"
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
    address = "0.0.0.0:8200"
    tls_disable = true
}

vault {
  address = "http://vault:8200"
}
