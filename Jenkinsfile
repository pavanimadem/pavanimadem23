pipeline {
  agent any

  tools {
    // Install the Maven version configured as "M2_HOME" and add it to the path.
    maven "M2_HOME"
  }
  environment{
	AWS_ACCOUNT_ID = "962826464166" 
	AWS_DEFAULT_REGION = "us-east-1"
	IMAGE_REPO_NAME = "webapp"
	IMAGE_TAG = "${BUILD_NUMBER}"
	REPOSIT_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazon.aws.com/${IMAGE_REPO_NAME}"
  }

  stages {
    
  stage('GIT Clone') {
            steps {
                checkout([
                 $class: 'GitSCM',
                 branches: [[name: 'Docker']],
                 userRemoteConfigs: [[
                    url:  "https://github.com/PavanDeepakPagadala/PavanDevOpsProject.git",
                    credentialsId: '',
                 ]]
                ])
            }
        }
	stage('Build') {
	     steps {
	         sh "mvn clean  package"
	     }
	}
	stage('Test') {
	    steps {
	        sh "mvn clean verify -DskipITs=true',junit '**/target/surefire-reports/TEST-*.xml'archive 'target/*.jar"

	    }
	}
	
	//TO upload war file into S3 bucket using IAM role and S3Profile configuration in jenkins.
	 stage('Upload To S3 Bucket ') {
      steps {
        s3Upload consoleLogLevel: 'INFO',
	dontSetBuildResultOnFailure: false,
	dontWaitForConcurrentBuildCompletion: false,
	entries: [
				[
					bucket: 'testbucketpav', 
					excludedFile: '/webapp/target',
					flatten: false,
					gzipFiles: false,
					keepForever: false,
					managedArtifacts: false,
					noUploadOnFailure: false,
					selectedRegion: 'us-east-1',
					showDirectlyInBrowser: false,
					sourceFile: '**/webapp/target/*.war',
					storageClass: 'STANDARD',
					uploadFromSlave: false,
					useServerSideEncryption: false
				]
			], 
	pluginFailureResultConstraint: 'FAILURE', 
	profileName: 'S3Profile', //Give same name as configured in jenkins
	userMetadata: []

      }
    }
	//TO build docker image and push to AWS ECR repository by taking war file from S3 bucket
	//Use docker context use command inside job directory to build files using Dockerfile
	stage('Docker Image Upload') {
		steps {
			script {
				sh "sudo aws s3 cp s3://testbucketpav/webapp/target/webapp.war /var/lib/jenkins/workspace/Docker/" //download war file from s3 to job directory for build
				sh "pwd"
				sh "sudo aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | sudo docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
				sh "sudo docker build -t ${IMAGE_REPO_NAME} ." 
				sh "sudo docker tag ${IMAGE_REPO_NAME} ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
				sh "sudo docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
			}
		}
	}

	stage('Running Docker Container') {
		steps {
			script {
				sh "sudo docker rm -f webapp || true"
				sh "sudo docker pull ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG} "
				sh "sudo docker tag ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG} webapp"
				sh "sudo docker rmi ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
				sh "sudo docker run --name webapp -itd -p 8082:8080 webapp"
			}
		}
	}
	
  

  }

  post {
	always {
		
		emailext body: '$DEFAULT_CONTENT', //configure message in body in jenkins
		 subject: 'Jenkins Build Status', 
		 to: 'pavandeepakpagadala@gmail.com'
		

	}
  }

}
