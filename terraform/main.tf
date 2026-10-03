terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "local" {}

# 1. Simular la creacion de un servidor
resource "local_file" "servidor_produccion" {
  content  = "Servidor Ubuntu 24.04 - IP:192.168.1.100"
  filename = "${path.module}/servidor_simulado.txt"
}

# 2. Puente Terraform -> Ansible
resource "local_file" "generar_inventario_ansible" {
  content = <<EOF
[produccion]
localhost ansible_connection=local

[produccion:vars]
entorno=produccion_critica
EOF

  filename = "${path.module}/../ansible/hosts.ini"

  depends_on = [
    local_file.servidor_produccion
  ]
}