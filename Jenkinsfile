pipeline {
    agent any
    
    environment {
        GCR_KEY = credentials('14fe56fa-a621-4441-bcac-c62fe88f9ada')
        GIT_CREDENTIALS = credentials('90d3ec9e-4c85-4598-8051-00529ac86729')
        EMAIL_NOTIFICATION = credentials('033337c4-31b5-4ae3-816f-6d11c3d96a4e')
        DOCKER_IMAGE = 'hdfcergo:latest'
		CONTAINER_NAME='hdfcergo-c'
		APP_NAME='hdfcergo-test'
		GOOGLE_APPLICATION_CREDENTIALS='/var/opt/key.json'
		GCLOUD_PATH='/root/google-cloud-sdk/bin'
		PROJECT_ID= 'cellular-sylph-392206'
		//GCR_KEY='/home/gcr-key.json'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout the development branch
                git branch: 'main', credentialsId: GIT_CREDENTIALS, url: 'https://github.com/manishsaini1174/HDFC_ERGO-task.git'
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
                 sh '/usr/local/bin/sonar-scanner' 
            }
        }

        stage('Docker Build') {
    	    //agent any
              steps {
         	    sh 'docker build -t ${DOCKER_IMAGE} .'
            }
       }
       
        stage('Push Docker image to GCR') {
              steps {
                    // Authenticate Docker to GCR
                    sh "/home/google-cloud-sdk/bin/gcloud auth configure-docker"
                    
                    // Tag and push the Docker image to GCR
                 sh "docker tag ${DOCKER_IMAGE} gcr.io/${PROJECT_ID}/${DOCKER_IMAGE}"
                 sh "docker push gcr.io/${PROJECT_ID}/${DOCKER_IMAGE}"
            }
        }

        
        stage('Deploy to GKE') {
            steps {
                //withEnv(["$GCLOUD_PATH=/home/google-cloud-sdk/bin/gcloud"]) {
                    sh "/home/google-cloud-sdk/bin/gcloud version"
                    sh "/home/google-cloud-sdk/bin/gcloud container clusters get-credentials hdfcergo --zone us-central1-f --project cellular-sylph-392206"
                    sh "/home/google-cloud-sdk/bin/kubectl create deployment --image=gcr.io/${PROJECT_ID}/${DOCKER_IMAGE}"
            }
        }
        
        stage('Autoscaling Configuration') {
            steps {
                // Configure autoscaling based on CPU usage
                
                // Example commands:
                 sh 'kubectl apply -f hpa-scaledown.yaml'
                 sh 'kubectl apply -f hpa-scaleup.yaml'
            }
        }
        
        stage('Email/Slack Notification') {
            steps {
                // Send success/failure notification
                
                // Example commands:
                 sh 'echo "The Deploymentis done successful!"'
            }
        }
    }
    post {
        always {
            emailext body: 'A Test EMail', recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']], subject: 'Test'
        }
    }
}