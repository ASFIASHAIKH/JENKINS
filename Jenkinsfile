pipeline {
    agent any

    environment {
        // Common
        TAG = "${GIT_COMMIT}"

        // For DEV
        DEV_DH_URL      = "https://registry.hub.docker.com/asfiyask/dev"
        DEV_DH_CREDS    = "Dockerhub_creds"
        DEV_DH_TAG      = "${env.TAG}"

        // For QA
        QA_DH_URL       = "https://registry.hub.docker.com/asfiyask/qa"
        QA_DH_CREDS     = "Dockerhub_creds"
        QA_DH_TAG       = "${env.TAG}"

        // For STAGE
        STAGE_DH_URL    = "https://registry.hub.docker.com/asfiyask/stage"
        STAGE_DH_CREDS  = "Dockerhub_creds"
        STAGE_DH_TAG    = "${env.TAG}"

        // For PROD
        PROD_DH_URL     = "https://registry.hub.docker.com/asfiyask/prod"
        PROD_DH_CREDS   = "Dockerhub_creds"
        PROD_DH_TAG     = "${env.TAG}"
    }

    stages {
        stage('Docker Image Build In Dev') {
            steps {
                echo "Docker image built successfully... Now logging in to Docker Hub and pushing the image."
                
                dockerBuildPush(env.DEV_DH_URL, env.DEV_DH_CREDS, env.DEV_DH_TAG)

                sh "echo Docker Image Pushed to DEV"
                sh "echo Deleting Local Docker DEV Image"
            }
        }
        stage('PULL TAG PUSH TO QA') {
            steps {
                dockerPULLTAGPUSH(env.DEV_DH_URL, env.DEV_DH_CREDS, env.DEV_DH_TAG, env.QA_DH_URL, env.QA_DH_CREDS, env.QA_DH_TAG)
            }
        }
        stage('PULL TAG PUSH TO STAGE') {
            steps {
                dockerPULLTAGPUSH(env.QA_DH_URL, env.QA_DH_CREDS, env.QA_DH_TAG, env.STAGE_DH_URL, env.STAGE_DH_CREDS, env.STAGE_DH_TAG)
            }
        }
        stage('PULL TAG PUSH TO PROD') {
            steps {
                dockerPULLTAGPUSH(env.STAGE_DH_URL, env.STAGE_DH_CREDS, env.STAGE_DH_TAG, env.PROD_DH_URL, env.PROD_DH_CREDS, env.PROD_DH_TAG)
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

// For Docker Build and Push
def dockerBuildPush(String SRC_DH_URL, String SRC_DH_CREDS, String SRC_DH_TAG) {
    def app = docker.build("${SRC_DH_TAG}")
    docker.withRegistry("${SRC_DH_URL}", "${SRC_DH_CREDS}") {
        app.push()
    }
}

// For Docker Pull, Tag, and Push
def dockerPULLTAGPUSH(String SRC_DH_URL, String SRC_DH_CREDS, String SRC_DH_TAG, String DEST_DH_URL, String DEST_DH_CREDS, String DEST_DH_TAG) {
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
