pipeline {
    agent { label 'wsl' }

    stages {
        stage('1. Auditoria de Codigo (Linting)') {
            steps {
                echo 'Validando sintaxis de Terraform y Ansible...'

                dir('terraform') {
                    sh 'rm -rf .terraform'
                    sh 'terraform init -input=false -reconfigure'
                    sh 'terraform validate'
                }

                dir('ansible') {
                    sh 'ansible-playbook --syntax-check playbook.yml'
                }
            }
        }

        stage('2. Planificacion (Terraform Plan)') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('3. Aprobacion Manual (Gatekeeper)') {
            steps {
                input message: 'El Terraform plan se ve correcto? Aprobar infraestructura',
                      ok: 'Aprobar y Desplegar'
            }
        }

        stage('4. Aprovisionamiento (Terraform Apply)') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('5. Configuracion Ansible') {
            steps {
                dir('ansible') {
                    echo 'Esperando 5 seg a que la red del servidor se estabilice'
                    sleep 5
                    sh 'ansible-playbook -i hosts.ini playbook.yml'
                }
            }
        }
    }
}