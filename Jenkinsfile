pipeline {
    agent any

    environment {
        EMAIL_RECIPIENT = 'ramyashridharmoger@gmail.com'
    }

    parameters {
        string(name: 'DOCKER_IMAGE_NAME', defaultValue: 'my-node-app', description: 'Docker Image Name')
        string(name: 'DOCKER_REGISTRY', defaultValue: 'docker.io', description: 'Docker Registry')
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker Image Tag')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ramyashridhar/Sample-my-node-app.git'
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
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', 
                                                  usernameVariable: 'DOCKER_USERNAME', 
                                                  passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Securely login to Docker Hub
                        bat """
                            echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                        """
                        // Push Docker image to Docker Hub
                        bat "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
                    }
               }
            }
        }
        stage('Deploy to Staging') {
            steps {
                script {
                    bat 'ssh user@staging-server "docker pull ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG} && docker run -d ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}" || exit 1'
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
