pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'boci2468'
        IMAGE_NAME      = 'devops-demo'
        IMAGE_TAG       = 'latest'
    }

    stages {
        stage('1. Code Pull and Lint Check') {
            steps {
                echo 'Checking out code structure from GitHub...'
                // You can add your python linter tests here later
            }
        }

        stage('2. Build Docker Container Image') {
            steps {
                echo 'Compiling layers and building local image structure...'
                sh "docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('3. Secure Authentication & Push to Docker Hub') {
            steps {
                // Securely injects your credentials from the Jenkins locker environment safely
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    echo 'Logging into secure remote container registry registry...'
                    sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                    
                    echo 'Pushing image onto public target hub...'
                    sh "docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}