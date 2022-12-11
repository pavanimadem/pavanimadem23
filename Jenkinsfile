pipeline {
  agent any

  tools {
    // Install the Maven version configured as "M2_HOME" and add it to the path.
    maven "M2_HOME"
  }

  stages {
    
	
	
	//stage('Clone') {
    //  steps {
        // Get some code from a GitHub repository
  //       git branch: "main", url: "https://github.com/PavanDeepakPagadala/PavanDevOpsProject.git"
		
//}
//}

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
	stage('Clean'){
		steps{
			sh "rm -rf /opt/tomcat/webapps/webapp.war"
		}
	}
	stage('S3 Download') {
	    steps {
			
	        sh " sudo chmod -R 777 /root/jenkinsscripts/tomcatscript.sh" 
	    }
	}
	
	
  

  }

}
