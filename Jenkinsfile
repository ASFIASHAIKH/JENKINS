pipeline {
    agent any

    environment {
        TAG = "${GIT_COMMIT}"

        // For DEV
        DEV_DH_URL    = "https://registry.hub.docker.com/asfiyask/dev"
        DEV_DH_CREDS  = "Dockerhub_creds"
        DEV_DH_TAG    = "${env.TAG}"

        // For QA
        QA_DH_URL     = "https://registry.hub.docker.com/asfiyask/qa"
        QA_DH_CREDS   = "Dockerhub_creds"
        QA_DH_TAG     = "${env.TAG}"

        // For STAGE
        STAGE_DH_URL    = "https://registry.hub.docker.com/asfiyask/stage"
        STAGE_DH_CREDS  = "Dockerhub_creds"
        STAGE_DH_TAG    = "${env.TAG}"

        // For PROD
        PROD_DH_URL    = "https://registry.hub.docker.com/asfiyask/prod"
        PROD_DH_CREDS  = "Dockerhub_creds"
        PROD_DH_TAG    = "${env.TAG}"
    }

    stages {
        stage('Docker Image Build In Dev') {
            steps {
                echo "Docker image built successfully... Now logging in to Docker Hub and pushing the image."
                DockerBuildPush(DEV_DH_URL, DEV_DH_CREDS, DEV_DH_TAG)
                sh "echo Docker Image Pushed to DEV"
                sh "echo Deleting Local Docker DEV Image"
            }
        }
        
        stage('PULL TAG PUSH TO QA') {
            steps {
                DockerPULLTAGPUSH(DEV_DH_URL, DEV_DH_CREDS, DEV_DH_TAG, QA_DH_URL, QA_DH_CREDS, QA_DH_TAG)
            }
        }
        
        stage('PULL TAG PUSH TO STAGE') {
            steps {
                DockerPULLTAGPUSH(QA_DH_URL, QA_DH_CREDS, QA_DH_TAG, STAGE_DH_URL, STAGE_DH_CREDS, STAGE_DH_TAG)
            }
        }
        
        stage('PULL TAG PUSH TO PROD') {
            steps {
                DockerPULLTAGPUSH(STAGE_DH_URL, STAGE_DH_CREDS, STAGE_DH_TAG, PROD_DH_URL, PROD_DH_CREDS, PROD_DH_TAG)
            }
        }
    }
    
    post { 
        always { 
            echo 'Deleting Project now !! '
            deleteDir()
        }
    }
}

// Function for Docker Build and Push
def DockerBuildPush(String SRC_DH_URL, String SRC_DH_CREDS, String SRC_DH_TAG) {
    def app = docker.build("${SRC_DH_TAG}")
    docker.withRegistry("${SRC_DH_URL}", "${SRC_DH_CREDS}") {
        app.push()
    }
}

// Function for Docker Pull, Tag, and Push
def DockerPULLTAGPUSH(String SRC_DH_URL, String SRC_DH_CREDS, String SRC_DH_TAG, String DEST_DH_URL, String DEST_DH_CREDS, String DEST_DH_TAG) {
    // Pulling image
    docker.withRegistry("${SRC_DH_URL}", "${SRC_DH_CREDS}") {
        docker.image("${SRC_DH_TAG}").pull()
    }
    sh 'echo Image Pulled Successfully..!'

    // Tagging Docker Image
    sh 'echo Tagging Docker Image'
    sh "docker tag ${SRC_DH_TAG} ${DEST_DH_TAG}"

    // Pushing to Destination Registry
    docker.withRegistry("${DEST_DH_URL}", "${DEST_DH_CREDS}") {
        docker.image("${DEST_DH_TAG}").push()
    }
    sh 'echo Image Pushed Successfully..!'
    sh 'echo Deleting Local Docker Image'
    sh "docker image rm ${SRC_DH_TAG}"
    sh "docker image rm ${DEST_DH_TAG}"
}
