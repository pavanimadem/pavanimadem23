pipeline {
  agent any

  tools {
    // Install the Maven version configured as "M2_HOME" and add it to the path.
    maven "M2_HOME"
  }

  stages {
    
	
	
	stage('Clone') {
      steps {
        // Get some code from a GitHub repository
         git branch: "main", url: "https://github.com/PavanDeepakPagadala/PavanDevOpsProject.git"
		
}
}
	stage('Compile') {
	     steps {
	         sh "mvn clean package"
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
					selectedRegion: 'ap-southeast-1',
					showDirectlyInBrowser: false,
					sourceFile: '**/webapp/target/*.war',
					storageClass: 'STANDARD',
					uploadFromSlave: false,
					useServerSideEncryption: false
				]
			], 
	pluginFailureResultConstraint: 'FAILURE', 
	profileName: 'S3 Bucket',
	userMetadata: []

      }
    }
	
	
  

  }

}
