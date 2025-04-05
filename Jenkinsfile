pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-node-app'  // Docker image name
        DOCKER_REGISTRY = 'docker.io'  // Docker Hub registry
        IMAGE_TAG = 'latest'
        EMAIL_RECIPIENT = 'ramyashridharmoger@gmail.com'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ramyashridhar/my-node-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat 'docker build -t my-node-app:latest .'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    bat 'docker run --rm my-node-app:latest npm test'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        bat 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    }

                    bat 'docker tag ${DOCKER_IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}'
                    bat 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}'
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                script {
                    bat 'ssh user@staging-server "docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG} && docker run -d ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"'
                }
            }
        }
    }

    post {
        always {
            emailext(
                to: "${EMAIL_RECIPIENT}",
                subject: "Build ${currentBuild.currentResult}: ${env.JOB_NAME}",
                body: "The build status is ${currentBuild.currentResult}. Check the Jenkins job for more details."
            )
        }
        success {
            emailext(
                to: "${EMAIL_RECIPIENT}",
                subject: "Build Success: ${env.JOB_NAME}",
                body: "The build was successful! The application has been deployed to staging."
            )
        }
        failure {
            emailext(
                to: "${EMAIL_RECIPIENT}",
                subject: "Build Failed: ${env.JOB_NAME}",
                body: "The build or deployment failed. Please check the Jenkins logs for details."
            )
        }
    }
}
