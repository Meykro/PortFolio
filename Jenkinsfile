pipeline {
    agent any

    environment {
        IMAGE_NAME = "meykro/portfolio"
        TAG = "latest"
    }

    stages {
        stage('Cloner le repo') {
            steps {
                git url: 'https://github.com/Meykro/PortFolio.git', branch: 'main'
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Déployer dans Docker local (Portainer)') {
            steps {
                script {
                    sh """
                    docker stop portfolio-container || true
                    docker rm portfolio-container || true
                    docker run -d --name portfolio-container -p 8080:80 ${IMAGE_NAME}:${TAG}
                    """
                }
            }
        }
    }
}
