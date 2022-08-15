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
        // Get some code from a GitHub repository
        //git 'https://github.com/PavanDeepakPagadala/PavanDevOpsProject.git'

        // Run Maven on a Unix agent.
        sh "mvn -Dmaven.test.failure.ignore=true clean package"

        // To run Maven on a Windows agent, use
        // bat "mvn -Dmaven.test.failure.ignore=true clean install package"
      }

      post {
        // If Maven was able to run the tests, even if some of the test
        // failed, record the test results and archive the jar file.
        success {
          junit '**/target/surefire-reports/TEST-*.xml'
          archiveArtifacts 'server/target/*.jar'
        }
      }
    }
    stage('S3 Upload') {
      steps {
        s3Upload consoleLogLevel: 'INFO',
          dontSetBuildResultOnFailure: false,
          dontWaitForConcurrentBuildCompletion: false,
          entries: [
            [
              bucket: 'my-practice-devops-test-bucket',
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
          ], pluginFailureResultConstraint: 'FAILURE', profileName: 'S3 Bucket', userMetadata: []
      }
    }
    stage('SSH Transfer') {
      steps {
        sshPublisher(
          continueOnError: false, failOnError: true,
          publishers: [
            sshPublisherDesc(
              configName: 'ansible',
              transfers: [
                sshTransfer(
                  cleanRemote: false, excludes: '', execCommand: 'ansible-playbook -i /home/ansadmin/hosts /home/ansadmin/copy-playbook.yml',
                  execTimeout: 120000,
                  flatten: false,
                  makeEmptyDirs: false,
                  noDefaultExcludes: false,
                  patternSeparator: '[, ]+',
                  remoteDirectory: '//home//ansadmin', remoteDirectorySDF: false,
                  removePrefix: 'webapp/target',
                  sourceFiles: 'webapp/target/*.war'
                )
              ],
              usePromotionTimestamp: false,
              useWorkspaceInPromotion: false,
              verbose: true
            )
          ]
        )

      }
    }

  }

}
