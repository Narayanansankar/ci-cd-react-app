pipeline {
    // Run on any available Jenkins agent
    agent any

    // Environment variables available to all stages
    environment {
        DOCKERHUB_USERNAME = 'narayanansankar' // Your username is correct here
        DOCKER_IMAGE_NAME  = 'ci-cd-react-app'
    }

    stages {
        // Stage 1: Get the source code from GitHub
        stage('Checkout Code') {
            steps {
                echo 'Checking out the source code...'
                checkout scm
            }
        }

        // Stage 2: Build the production Docker image
        stage('Build Docker Image') {
            steps {
                echo "Building image: ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}"
                script {
                    docker.build("${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }

        // Stage 3: Push the image to a container registry
        stage('Push to Docker Hub') {
            steps {
                // --- FIX STARTS HERE ---
                // The logic is wrapped in a script block to resolve the syntax error.
                script {
                    echo "Pushing image to Docker Hub..."
                    withDockerRegistry(credentialsId: 'dockerhub-credentials') {
                        // Define the image once to be more efficient
                        def customImage = docker.image("${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:${env.BUILD_ID}")
                        
                        // Push the tag with the build number
                        customImage.push()

                        // Push the 'latest' tag
                        customImage.push('latest')
                    }
                }
                // --- FIX ENDS HERE ---
            }
        }

        // Stage 4: Deploy the application
        stage('Deploy Application') {
            steps {
                echo 'Deploying the new container...'
                sh "docker stop ${DOCKER_IMAGE_NAME} || true"
                sh "docker rm ${DOCKER_IMAGE_NAME} || true"
                sh "docker run -d --name ${DOCKER_IMAGE_NAME} -p 3000:80 ${DOCKERHUB_USERNAME}/${DOCKER_IMAGE_NAME}:latest"
            }
        }
    }
}
