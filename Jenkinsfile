pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = credentials('AZURE_CREDENTIALS')
        TF_VAR_admin_password = credentials('TF_VAR_admin_password')
    }

    parameters {
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Environment to Deploy (e.g., dev)')
        booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'Apply Terraform changes automatically')
    }

    stages {
        stage('Azure Login') {
            steps {
                script {
                    echo "Logging into Azure using Service Principal..."
                    def creds = readJSON text: AZURE_CREDENTIALS
                    sh """
                    az login --service-principal \
                        -u ${creds.client_id} \
                        -p ${creds.client_secret} \
                        --tenant ${creds.tenant_id}
                    az account set --subscription ${creds.subscription_id}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    echo "Initializing Terraform..."
                    sh 'terraform init -upgrade'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    echo "Running Terraform Plan..."
                    sh 'terraform plan -var="admin_password=$TF_VAR_admin_password" -out=tfplan'
                    sh 'ls -l tfplan'
                }
            }
        }

        stage('Publish Plan Artifact') {
            steps {
                echo "Archiving Terraform Plan..."
                archiveArtifacts artifacts: "environments/${params.ENVIRONMENT}/tfplan", fingerprint: true
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.APPLY_CHANGES == true }
            }
            steps {
                dir("environments/${params.ENVIRONMENT}") {
                    echo "Applying Terraform Plan..."
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
    }
}
