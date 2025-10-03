pipeline {
    // Run on any available Jenkins agent
    agent any

    // Environment variables available to all stages
    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username' // <-- CHANGE THIS
        DOCKER_IMAGE_NAME  = 'ci-cd-react-app'
    }

    stages {
        // Stage 1: Get the source code from GitHub
        stage('Checkout Code') {
            steps {
                echo 'Checking out the source code...'
                // This command uses the Git settings you'll configure in the Jenkins job
                checkout scm
            }
        }

        // Stage 2: Build the production Docker image
        stage('Build Docker Image') {
            steps {
                echo "Building image: ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}"
                script {
                    // Use the Docker Pipeline plugin to build the image
                    // The tag is the unique Jenkins BUILD_ID for versioning
                    docker.build("${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        // Stage 3: Push the image to a container registry
        stage('Push to Docker Hub') {
            steps {
                echo "Pushing image to Docker Hub..."
                // Log in to Docker Hub using the credentials you stored in Jenkins
                withDockerRegistry(credentialsId: 'dockerhub-credentials') {
                    // Push the uniquely tagged image
                    docker.image("${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").push()
                    // Also push it with the 'latest' tag for easy deployment
                    docker.image("${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:${env.BUILD_ID}").push('latest')
                }
            }
        }

        // Stage 4: Deploy the application
        stage('Deploy Application') {
            steps {
                echo 'Deploying the new container...'
                // Use shell commands to stop and remove the old container if it exists
                sh "docker stop ${DOCKER_IMAGE_NAME} || true"
                sh "docker rm ${DOCKER_IMAGE_NAME} || true"

                // Run a new container from the 'latest' image we just pushed
                // Map port 3000 on the host to port 80 in the container
                sh "docker run -d --name ${DOCKER_IMAGE_NAME} -p 3000:80 ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:latest"
            }
        }
    }
}