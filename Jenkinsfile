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
                
                dockerBuildPush("${env.DEV_DH_URL}", "${env.DEV_DH_CREDS}", "${env.DEV_DH_TAG}")

                sh "echo Docker Image Pushed to DEV"
                sh "echo Deleting Local Docker DEV Image"
            }
        }

        stage('PULL TAG PUSH TO QA') {
            steps {
                script {
                    docker.withRegistry("${env.DEV_DH_URL}", "${env.DEV_DH_CREDS}") {
                        docker.image("${env.DEV_DH_TAG}").pull()
                    }
                }

                sh 'echo Image pulled from DEV'
                sh 'echo Tagging Docker image from Dev to QA'
                sh "docker tag teamcloudethix/dev-cdex-jenkins:latest teamcloudethix/qa-cdex-jenkins:latest" 

                script {
                    docker.withRegistry("${env.QA_DH_URL}", "${env.QA_DH_CREDS}") {
                        docker.image("${env.QA_DH_TAG}").push()
                    }
                }
            }
        }

        stage('PULL TAG PUSH TO STAGE') {
            steps {
                script {
                    docker.withRegistry("${env.QA_DH_URL}", "${env.QA_DH_CREDS}") {
                        docker.image("${env.QA_DH_TAG}").pull()
                    }
                }

                sh 'echo Image pulled from QA'
                sh 'echo Tagging Docker image from QA to STAGE'
                sh "docker tag teamcloudethix/dev-cdex-jenkins:latest teamcloudethix/qa-cdex-jenkins:latest" 

                script {
                    docker.withRegistry("${env.STAGE_DH_URL}", "${env.STAGE_DH_CREDS}") {
                        docker.image("${env.STAGE_DH_TAG}").push()
                    }
                }
            }
        }

        stage('PULL TAG PUSH TO PROD') {
            steps {
                script {
                    docker.withRegistry("${env.STAGE_DH_URL}", "${env.STAGE_DH_CREDS}") {
                        docker.image("${env.STAGE_DH_TAG}").pull()
                    }
                }

                sh 'echo Image pulled from STAGE'
                sh 'echo Tagging Docker image from STAGE to PROD'
                sh "docker tag teamcloudethix/dev-cdex-jenkins:latest teamcloudethix/qa-cdex-jenkins:latest" 

                script {
                    docker.withRegistry("${env.PROD_DH_URL}", "${env.PROD_DH_CREDS}") {
                        docker.image("${env.PROD_DH_TAG}").push()
                    }
                }
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
