pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal-4' // Jenkins Credential ID for Azure Service Principal
        REACT_APP_NAME = 'deepak-react-frontend-app'
        RESOURCE_GROUP = 'deepak-react-resource'
    }

    stages {
        stage('Checkout React App') {
            steps {
                git url: 'https://github.com/deepakmanghani1511/react-terraform.git', branch: 'main'
            }
        }

        stage('Install Dependencies & Build React App') {
            steps {
                sh 'npm install'
                sh 'npm run build'
                sh 'zip -r build.zip build'
            }
        }

        stage('Initialize Terraform') {
            steps {
                dir('terraform') {
                    withCredentials([azureServicePrincipal(
                        credentialsId: env.AZURE_CREDENTIALS_ID,
                        subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                        clientIdVariable: 'ARM_CLIENT_ID',
                        clientSecretVariable: 'ARM_CLIENT_SECRET',
                        tenantIdVariable: 'ARM_TENANT_ID'
                    )]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('terraform') {
                    withCredentials([azureServicePrincipal(
                        credentialsId: env.AZURE_CREDENTIALS_ID,
                        subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                        clientIdVariable: 'ARM_CLIENT_ID',
                        clientSecretVariable: 'ARM_CLIENT_SECRET',
                        tenantIdVariable: 'ARM_TENANT_ID'
                    )]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Deploy React App to Azure') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: env.AZURE_CREDENTIALS_ID,
                    subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                    clientIdVariable: 'ARM_CLIENT_ID',
                    clientSecretVariable: 'ARM_CLIENT_SECRET',
                    tenantIdVariable: 'ARM_TENANT_ID'
                )]) {
                    sh '''
                    npm install -g azure-cli
                    az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
                    az webapp deployment source config-zip \
                        --resource-group $RESOURCE_GROUP \
                        --name $REACT_APP_NAME \
                        --src build.zip
                    '''
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
