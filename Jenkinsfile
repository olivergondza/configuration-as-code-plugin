// Test out Azure Container Instances
pipeline {
    agent none
    stages {
        stage('Build JDK8') {
            agent { label 'maven' }
            steps {
                sh 'mvn -Dmaven.test.failure.ignore --batch-mode --errors -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn clean install'
            }
        }
    }
}

buildPlugin(jenkinsVersions: [null, "2.107.1"], timeout: 180, failFast: false)
