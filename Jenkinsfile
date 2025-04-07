pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal-4'
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'deep-react-web-api'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/deepakmanghani1511/react-terraform.git'
            }
        }

        stage('Install & Build React App') {
            steps {
                dir('integrated-react') {
                    bat 'npm install'
                    bat 'npm run build'
                }
            }
        }

        stage('Test Terraform') {
            steps {
                dir('terraform-integrated-react') {
                    bat 'terraform --version'
                }
            }
        }

        stage("Terraform Setup") {
            steps {
                dir("terraform-integrated-react") {
                    bat 'terraform init'
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS_ID)]) {
                    bat 'az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%'
                    bat 'powershell Compress-Archive -Path integrated-react\\build\\* -DestinationPath build.zip -Force'
                    bat 'az webapp deploy --resource-group %RESOURCE_GROUP% --name %APP_SERVICE_NAME% --src-path build.zip --type zip'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful!'
        }
        failure {
            echo 'Deployment Failed!'
        }
    }
}
