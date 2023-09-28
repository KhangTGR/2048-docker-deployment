pipeline {
  agent any
  stages {
    stage('Setup') {
      steps {
        sh '''# Build a Docker image for Docker 2048 GameServer
cd dockerfiles
docker build -t docker-2048-gameserver-image:latest - <2048Game.Dockerfile

# Run 2048 game in Docker container
docker run -d -p 80:80 docker-2048-gameserver-image:latest --name docker-2048-gameserver-container
'''
      }
    }

  }
}