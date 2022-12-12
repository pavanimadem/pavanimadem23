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
	IMAGE_TAG = "latest"
	REPOSIT_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazon.aws.com/${IMAGE_REPO_NAME}"
  }

  stages {
    
//For webhook
  stage('Checkout SCM') {
            steps {
                checkout([
                 $class: 'GitSCM',
                 branches: [[name: 'main']],
                 userRemoteConfigs: [[
                    url:  "https://github.com/PavanDeepakPagadala/PavanDevOpsProject.git",
                    credentialsId: '',
                 ]]
                ])
            }
        }
	stage('Compile') {
	     steps {
	         sh "mvn clean  package"
	     }
	}
	stage('Test') {
	    steps {
	        sh "mvn clean verify -DskipITs=true',junit '**/target/surefire-reports/TEST-*.xml'archive 'target/*.jar"

	    }
	}
	
	 stage('S3 Upload') {
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
	profileName: 'S3Profile',
	userMetadata: []

      }
    }
	//To remove old war files
	stage('Clean'){
		steps{
			sh "sudo rm -f /opt/tomcat/webapps/webapp.war"
		}
	}
	//TO download war files from s3 bucket to tomcat 
	stage('Deploy to Tomcat from S3') {
	    steps {
			

	        sh " sudo aws s3 cp s3://testbucketpav/webapp/target/webapp.war /opt/tomcat/webapps/" 
	    }
	}
	
	stage('Email'){
		steps {
		emailext body: '$DEFAULT_CONTENT', 
		 subject: 'Jenkins Build Status', 
		 to: 'pavandeepakpagadala@gmail.com'
		}
	}
	stage('Publish to ECR') {
		steps {
			script {
				sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION}  | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
				dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
				sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
				sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
			}
		}
	}
	
  

  }

}
