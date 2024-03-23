pipeline {
    agent any

    environment {
        //common
        TAG             = "${GIT_COMMIT}"

        // FOR DEV
        DEV_DH_URL    	= "https://registry.hub.docker.com/asfiyask/dev"
        DEV_DH_CREDS  	= "Dockerhub_creds"
        DEV_DH_TAG    	= "${env.TAG}"

        // FOR QA
        QA_DH_URL	  	= "https://registry.hub.docker.com/asfiyask/qa"
        QA_DH_CREDS   	= "Dockerhub_creds"
        QA_DH_TAG 	 	= "${env.TAG}"

        // FOR STAGE
        STAGE_DH_URL  	= "https://registry.hub.docker.com/asfiyask/stage"
        STAGE_DH_CREDS 	= "Dockerhub_creds"
        STAGE_DH_TAG	= "${env.TAG}"

        // FOR PROD
        PROD_DH_URL		= "https://registry.hub.docker.com/asfiyask/prod"
        PROD_DH_CREDS	= "Dockerhub_creds"
        PROD_DH_TAG		= "${env.TAG}"

    }
    stages {
        stage('Docker Image Build In Dev') {
            steps {
            echo "Docker image built successfully... Now logging in to Docker Hub and pushing the image."
            
            dockerBuildPush(${env.DEV_DH_URL} , ${env.DEV_DH_CREDS} , ${env.DEV_DH_TAG})

            sh "echo Docker Image Pushed to DEV"
            sh "echo Deleting Local Docker DEV Image"

            }
        }
        stage('PULL TAG PUSH TO QA') {
            steps {
                dockerPULLTAGPUSH($${env.DEV_DH_URL} , ${env.DEV_DH_CREDS} , ${env.DEV_DH_TAG} , {env.QA_DH_URL} , ${env.QA_DH_CREDS} , ${env.QA_DH_TAG})
            }
        }
        stage('PULL TAG PUSH TO STAGE') {
            steps {
                dockerPULLTAGPUSH($${env.QA_DH_URL} , ${env.QA_DH_CREDS} , ${env.QA_DH_TAG} , {env.STAGE_DH_URL} , ${env.STAGE_DH_CREDS} , ${env.STAGE_DH_TAG})

            }
        }
        stage('PULL TAG PUSH TO PROD') {
            steps {
                dockerPULLTAGPUSH($${env.STAGE_DH_URL} , ${env.STAGE_DH_CREDS} , ${env.STAGE_DH_TAG} , {env.PROD_DH_URL} , ${env.PROD_DH_CREDS} , ${env.PROD_DH_TAG})

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



//FOR DOCKER PUSH TAG FOR DEV
def dockerBuildPush(string SRC_DH_URL , string SRC_DH_CREDS, string SRC_DH_TAG) {
        def app = docker.build('$(env.SRC_DH_TAG)')
        docker.withRegistry('$(env.SRC_DH_URL)', '$(env.SRC_DH_CREDS)') {
        app.push()
        }
}	

//FOR DOCKER PULL TAG PUSH FOR QA , STAGE AND PROD
def dockerPULLTAGPUSH(string SRC_DH_URL , string SRC_DH_CREDS , string SRC_DH_TAG , string DEST_DH_URL , string DEST_DH_CREDS , string DEST_DH_TAG) {
		
        //FOR PULL 
		docker.withRegistry('$(env.SRC_DH_URL)', '$(env.SRC_DH_CREDS)') {
		docker.image("$(env.SRC_DH_TAG)").pull
        }
		sh 'echo Image Pulled from Successfully..!'
		
		//FOR TAG
		sh 'echo Taggig Docker Image'
		sh "docker tag $(env.SRC_DH_TAG) , $(env.DEST_DH_TAG)"
		
		//FOR PUSH
		docker.withRegistry('$(env.DEST_DH_URL)', '$(env.DEST_DH_CREDS)') {
		docker.image("$(env.DEST_DH_TAG)").push()
        }
		
		sh 'echo Image Pushed from Successfully..!'
		sh 'echo Deleting Local Docker Image'
		sh "docker image rm $(SRC_DH_TAG)"
		sh "docker image rm $(DEST_DH_TAG)"
