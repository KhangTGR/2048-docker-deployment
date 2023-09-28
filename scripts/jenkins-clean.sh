docker stop jenkins-blueocean
docker rm jenkins-blueocean
docker rmi jenkins-blueocean

docker stop jenkins-docker
docker rmi jenkins-docker

docker network rm jenkins
