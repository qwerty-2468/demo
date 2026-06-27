pipeline {
    // Run this orchestration process on any available worker agent
    agent any

    environment {
        DOCKER_USER = 'boci2468' // Your Docker Hub username
        // Securely map the username and password from your Jenkins store
        DOCKER_HUB_CREDS = credentials('docker-hub-credentials') 
    }

    stages {
        stage('1. Checkout Code') {
            steps {
                echo 'Cleaning up stale directory cache and pulling code...'
                cleanWs() 
                git branch: 'main', url: 'https://github.com/qwerty-2468/demo.git'
            }
        }

        stage('2. Run Python Unit Tests') {
            agent {
                docker {
                    image 'python:3.11-slim'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                echo 'Initializing virtual test environments inside isolated Python container...'
                sh '''
                    python -m pip install --upgrade pip
                    pip install pytest flask
                    pytest test_app.py
                '''
            }
        }

        stage('3. Build & Push Image') {
            steps {
                echo 'Compiling new production Docker image layer...'
                sh "docker build -t ${DOCKER_USER}/devops-demo:latest ."
                
                echo 'Authenticating with Docker Hub...'
                sh "echo \$DOCKER_HUB_CREDS_PW | docker login -u \$DOCKER_HUB_CREDS_USR --password-stdin"
                
                echo 'Pushing updated image to repository registry...'
                sh "docker push ${DOCKER_USER}/devops-demo:latest"
            }
        }

        stage('4. Hot-Swap Production Deploy') {
            steps {
                echo 'Recycling live application container on target environment...'
                // Because Jenkins runs on the host VM and mounts the docker socket,
                // it can modify the host runtime containers directly!
                sh '''
                    set -e
                    echo "Stopping existing app container..."
                    docker stop flask-dashboard-app >/dev/null 2>&1 || true
                    docker rm flask-dashboard-app >/dev/null 2>&1 || true
                    
                    echo "Removing stale local image cache..."
                    docker rmi ${DOCKER_USER}/devops-demo:latest >/dev/null 2>&1 || true
                    
                    echo "Pulling latest image build..."
                    docker pull ${DOCKER_USER}/devops-demo:latest
                    
                    echo "Launching web server on port 5001..."
                    docker run -d \
                      --restart=always \
                      --name flask-dashboard-app \
                      -p 5001:5000 \
                      ${DOCKER_USER}/devops-demo:latest
                    
                    echo "🎉 Complete automation successfully achieved!"
                '''
            }
        }
    }
}