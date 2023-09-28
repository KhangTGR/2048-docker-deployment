pipeline {
  agent any
  stages {
    stage('Setup') {
      steps {
        sh '''# Build a Docker image for Docker 2048 GameServer
/scripts/docker-setup.sh
'''
      }
    }
  }
}
