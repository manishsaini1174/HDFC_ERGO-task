pipeline {
    agent any
    
    environment {
        GKE_CREDENTIALS = credentials('<GKE_CREDENTIALS_ID>')
        GIT_CREDENTIALS = credentials('<GIT_CREDENTIALS_ID>')
        EMAIL_NOTIFICATION = credentials('<EMAIL_CREDENTIALS_ID>')
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the development branch
                git branch: 'development', credentialsId: GIT_CREDENTIALS, url: 'https://gitlab.com/manish1174/hdfcergo-task.git'
            }
        }
        
        stage('Build and Test') {
            steps {
                // Build and test your code
                 sh 'mvn clean install'
            }
        }
        
        stage('Code Quality') {
            steps {
                // Perform code scanning and quality checks
                 sh 'sonar-scanner' 
                 sh 'eslint . --fix'
            }
        }
        
        stage('Terraform Deployment') {
            steps {
                // Configure and deploy GKE Cluster using Terraform
                 sh 'terraform init' 
                 sh 'terraform apply -auto-approve' 
            }
        }
        
        stage('Autoscaling Configuration') {
            steps {
                // Configure autoscaling based on CPU usage
                
                // Example commands:
                 sh 'kubectl apply -f autoscaling-config.yaml'
            }
        }
        
        stage('Email/Slack Notification') {
            steps {
                // Send success/failure notification
                
                // Example commands:
                 sh 'echo "The Deploymentis done successful!" | mail -s "Deployment Notification" manishsaini1174@gmail.com'
            }
        }
    }
}