pipeline {
    agent any

    environment {
        // Adjust Docker image tag or Nginx output paths as needed
        NODE_IMAGE = 'node:20-alpine'
        APP_NAME   = 'angular-frontend'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Build Angular App') {
            steps {
                sh '''
                    docker run --rm \
                        -e CI=true \
                        -e NG_CLI_ANALYTICS=false \
                        -v "${WORKSPACE}":/app \
                        -w /app \
                        node:20-alpine \
                        sh -c "npm ci && npm run build -- --configuration=production"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                // Package the built static Angular files into an Nginx container
                sh "docker build -t ${APP_NAME}:latest ."
            }
        }

        stage('Deploy Container') {
            steps {
                // Stop any previous container running on port 80 and run the new one
                sh """
                    docker stop ${APP_NAME} || true
                    docker rm ${APP_NAME} || true
                    docker run -d --name ${APP_NAME} -p 80:80 ${APP_NAME}:latest
                """
            }
        }
    }

    post {
        always {
            // Clean workspace to save disk space in Vagrant VM
            cleanWs()
        }
        success {
            echo 'Angular pipeline executed successfully!'
        }
        failure {
            echo 'Angular pipeline failed.'
        }
    }
}
