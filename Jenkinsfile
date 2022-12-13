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
	REPOSIT_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazon.aws.com/${IMAGE_REPO_NAME}"
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
	//stage('SonarQube analysis') {
    //def scannerHome = tool 'SonarScanner 4.7';
      //  steps{
       // withSonarQubeEnv('sonarqube') { 
        // If you have configured more than one global server connection, you can specify its name
//      sh "${scannerHome}/bin/sonar-scanner"
        //sh "mvn sonar:sonar"
   // }
      //  }
       // }
	
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
				sh "sudo aws s3 cp s3://testbucketpav/webapp/target/webapp.war /var/lib/jenkins/workspace/Java_Pipeline_Application/"
				sh "pwd"
				sh "sudo aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 962826464166.dkr.ecr.us-east-1.amazonaws.com"
				 sh "docker build -t webapp ."
				sh "docker tag webapp:latest 962826464166.dkr.ecr.us-east-1.amazonaws.com/webapp:latest"
				sh "docker push 962826464166.dkr.ecr.us-east-1.amazonaws.com/webapp:latest"
			}
		}
	}
	
  

  }

}
